import 'package:connectivity_plus/connectivity_plus.dart';

/// Reports device connectivity and emits changes.
///
/// Abstracted behind an interface so repositories and the sync engine depend
/// on a boolean online/offline signal rather than `connectivity_plus` directly
/// — which also makes them trivial to fake in tests.
abstract interface class ConnectivityService {
  /// Whether the device currently has a network connection.
  Future<bool> get isOnline;

  /// Emits `true` when connectivity is (re)gained, `false` when lost.
  Stream<bool> get onStatusChange;
}

/// [ConnectivityService] backed by the `connectivity_plus` plugin.
final class ConnectivityPlusService implements ConnectivityService {
  /// Creates the service. Pass a [Connectivity] instance to override in tests.
  ConnectivityPlusService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isOnline async =>
      _isOnline(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_isOnline).distinct();

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
