import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity status. A hint only — connectivity does not guarantee
/// backend reachability; requests must still handle unavailability.
enum NetworkStatus { online, offline }

/// Contract for observing network-interface status as a hint.
abstract interface class ConnectivityService {
  NetworkStatus get current;
  Stream<NetworkStatus> get status;
  Future<void> dispose();
}

/// Platform adapter seam so tests can inject a fake source.
abstract interface class ConnectivitySource {
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
  Future<List<ConnectivityResult>> checkConnectivity();
}

class _PlatformConnectivitySource implements ConnectivitySource {
  final Connectivity _connectivity = Connectivity();

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() =>
      _connectivity.checkConnectivity();
}

/// Debounces noisy transitions and maps results to [NetworkStatus].
class ConnectivityServiceAdapter implements ConnectivityService {
  ConnectivityServiceAdapter({
    ConnectivitySource? source,
    this.debounce = const Duration(milliseconds: 400),
  }) : _source = source ?? _PlatformConnectivitySource();

  final ConnectivitySource _source;

  /// Debounce window for noisy transitions.
  final Duration debounce;

  final _controller = StreamController<NetworkStatus>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _debounce;
  NetworkStatus _current = NetworkStatus.online;
  bool _disposed = false;

  @override
  NetworkStatus get current => _current;

  @override
  Stream<NetworkStatus> get status => _controller.stream;

  /// Starts observing. Emits only on changes after the initial value.
  Future<void> init() async {
    final results = await _source.checkConnectivity();
    _current = _map(results);
    _sub = _source.onConnectivityChanged.listen((results) {
      if (_disposed) return;
      _debounce?.cancel();
      _debounce = Timer(debounce, () => _emit(_map(results)));
    });
  }

  void _emit(NetworkStatus next) {
    if (_disposed || next == _current) return;
    _current = next;
    _controller.add(next);
  }

  static NetworkStatus _map(List<ConnectivityResult> results) {
    if (results.isEmpty) return NetworkStatus.offline;
    final anyConnected = results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn ||
        r == ConnectivityResult.other);
    return anyConnected ? NetworkStatus.online : NetworkStatus.offline;
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    _debounce?.cancel();
    await _sub?.cancel();
    await _controller.close();
  }
}
