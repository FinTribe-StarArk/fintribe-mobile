import 'package:fintribe/core/sync/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'outbox_entry.freezed.dart';

/// A single queued offline mutation awaiting replay to the server.
///
/// [payload] is the entity's JSON body captured at write time, so the sync
/// engine can push it verbatim later without re-reading (possibly changed)
/// local state.
@freezed
abstract class OutboxEntry with _$OutboxEntry {
  const factory OutboxEntry({
    required String id,
    required String entityType,
    required String entityId,
    required OutboxOperation operation,
    required Map<String, dynamic> payload,
    @Default(SyncStatus.pending) SyncStatus status,
    @Default(0) int retryCount,
    String? lastError,
    required DateTime createdAt,
  }) = _OutboxEntry;

  const OutboxEntry._();
}
