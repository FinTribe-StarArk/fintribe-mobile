import 'dart:async';

import 'package:fintribe/core/network/connectivity_service.dart';
import 'package:fintribe/core/sync/outbox_dao.dart';
import 'package:fintribe/core/sync/sync_handler.dart';
import 'package:fintribe/core/utils/helpers/logger.dart';

/// Outcome of a [SyncEngine.sync] run.
final class SyncResult {
  const SyncResult({
    required this.pushed,
    required this.failed,
    this.skippedOffline = false,
  });

  /// Result for a run that was skipped because the device is offline.
  const SyncResult.offline() : this(pushed: 0, failed: 0, skippedOffline: true);

  /// Entries successfully pushed and removed from the outbox.
  final int pushed;

  /// Entries whose push failed (still queued for retry).
  final int failed;

  /// Whether the run was a no-op because there was no connectivity.
  final bool skippedOffline;

  @override
  String toString() =>
      'SyncResult(pushed: $pushed, failed: $failed, offline: $skippedOffline)';
}

/// Drains the offline outbox by delegating each entry to a registered
/// [SyncHandler]. Entity-agnostic: features plug in via [register].
///
/// Call [start] once to auto-sync whenever connectivity is regained, and
/// [sync] to flush on demand (e.g. right after a local write, or pull-to-sync).
final class SyncEngine {
  /// Creates a [SyncEngine].
  SyncEngine({required OutboxDao outboxDao, required ConnectivityService connectivity})
    : _outboxDao = outboxDao,
      _connectivity = connectivity;

  final OutboxDao _outboxDao;
  final ConnectivityService _connectivity;
  final Map<String, SyncHandler> _handlers = {};

  StreamSubscription<bool>? _connSub;
  bool _running = false;

  /// Registers a [handler] for its [SyncHandler.entityType]. Idempotent.
  void register(SyncHandler handler) => _handlers[handler.entityType] = handler;

  /// Begins auto-syncing when connectivity is (re)gained. Call once at startup.
  void start() {
    _connSub ??= _connectivity.onStatusChange.listen((online) {
      if (online) {
        AppLogger.I.d('🔄 Connectivity restored — draining outbox');
        unawaited(sync());
      }
    });
  }

  /// Stops listening for connectivity changes.
  Future<void> stop() async {
    await _connSub?.cancel();
    _connSub = null;
  }

  /// Attempts to push all pending outbox entries.
  ///
  /// Re-entrancy guarded — a concurrent call while a sync is in flight returns
  /// [SyncResult] with zero counts rather than double-pushing.
  Future<SyncResult> sync() async {
    if (_running) return const SyncResult(pushed: 0, failed: 0);
    if (!await _connectivity.isOnline) return const SyncResult.offline();

    _running = true;
    var pushed = 0;
    var failed = 0;
    try {
      final entries = await _outboxDao.pending();
      for (final entry in entries) {
        final handler = _handlers[entry.entityType];
        if (handler == null) {
          AppLogger.I.w('No SyncHandler for "${entry.entityType}" — skipping');
          continue;
        }
        try {
          await handler.push(entry);
          await _outboxDao.deleteById(entry.id);
          pushed++;
        } catch (e) {
          await _outboxDao.markFailed(entry.id, e.toString());
          failed++;
          AppLogger.I.e('Sync failed for ${entry.entityType}:${entry.entityId}', error: e);
        }
      }
    } finally {
      _running = false;
    }

    final result = SyncResult(pushed: pushed, failed: failed);
    AppLogger.I.d('✅ Sync complete — $result');
    return result;
  }
}
