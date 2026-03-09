import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

/// Supported gestures for proximity-based control.
enum ProximityGesture {
  swipeNext,     // 1 Wave (Rapid Near -> Far)
  swipePrevious, // 2 Waves
  scrollDown,    // 3 Waves
  scrollUp,      // 4 Waves
  holdDismiss,   // Hold (Near for > 1.5s)
  none,
}

/// A service to detect and broadcast proximity gestures.
class ProximityGestureDetector {
  final StreamController<ProximityGesture> _controller = StreamController<ProximityGesture>.broadcast();
  StreamSubscription<int>? _subscription;

  // Configuration
  static const Duration _waveWindow = Duration(milliseconds: 800);
  static const Duration _holdThreshold = Duration(milliseconds: 1500);

  // State
  DateTime? _nearStartTime;
  int _waveCount = 0;
  Timer? _waveTimer;
  bool _isNear = false;

  /// Stream of detected gestures.
  Stream<ProximityGesture> get gestures => _controller.stream;

  /// Start listening to proximity events.
  void start() {
    _subscription?.cancel();
    _subscription = ProximitySensor.events.listen(_handleEvent);
  }

  /// Stop listening to proximity events.
  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _waveTimer?.cancel();
  }

  void _handleEvent(int value) {
    // proximity_sensor package returns 1 (or >0) for near, 0 for far
    final bool currentlyNear = value > 0;

    if (currentlyNear && !_isNear) {
      // Transition: Far -> Near
      _isNear = true;
      _nearStartTime = DateTime.now();
    } else if (!currentlyNear && _isNear) {
      // Transition: Near -> Far
      _isNear = false;
      final duration = DateTime.now().difference(_nearStartTime!);

      if (duration < const Duration(milliseconds: 500)) {
        // It's a "Wave" (Rapid Near -> Far)
        _handleWave();
      } else if (duration >= _holdThreshold) {
        // It's a "Hold" (Near for > 1.5s)
        _emit(ProximityGesture.holdDismiss);
        _resetWaves();
      }
    }
  }

  void _handleWave() {
    _waveCount++;
    _waveTimer?.cancel();
    _waveTimer = Timer(_waveWindow, () {
      _processWaveCollection();
    });
  }

  void _processWaveCollection() {
    switch (_waveCount) {
      case 1:
        _emit(ProximityGesture.swipeNext);
        break;
      case 2:
        _emit(ProximityGesture.swipePrevious);
        break;
      case 3:
        _emit(ProximityGesture.scrollDown);
        break;
      case 4:
        _emit(ProximityGesture.scrollUp);
        break;
      default:
        // Ignore excessive waves
        break;
    }
    _resetWaves();
  }

  void _resetWaves() {
    _waveCount = 0;
    _waveTimer?.cancel();
  }

  void _emit(ProximityGesture gesture) {
    if (!_controller.isClosed) {
      _controller.add(gesture);
      debugPrint('ProximityGesture detected: $gesture');
    }
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
