import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:cineghar/features/sensors/domain/usecases/watch_light_sensor_usecase.dart';
import 'package:cineghar/features/sensors/domain/usecases/watch_proximity_sensor_usecase.dart';
import 'package:cineghar/features/sensors/domain/usecases/watch_gyroscope_sensor_usecase.dart';
import 'package:cineghar/features/sensors/presentation/providers/sensors_state.dart';
import 'package:cineghar/features/sensors/presentation/providers/sensors_providers.dart';

class SensorsViewModel extends Notifier<SensorsState> {
  late final WatchLightSensorUsecase _watchLightUsecase;
  late final WatchProximitySensorUsecase _watchProximityUsecase;
  late final WatchGyroscopeSensorUsecase _watchGyroscopeUsecase;

  StreamSubscription? _lightSub;
  StreamSubscription? _proximitySub;
  StreamSubscription? _gyroSub;

  Timer? _themeDebounceTimer;
  static const Duration _themeSwitchDelay = Duration(milliseconds: 1000);
  static const int _luxThreshold = 15;

  @override
  SensorsState build() {
    _watchLightUsecase = ref.read(watchLightSensorUsecaseProvider);
    _watchProximityUsecase = ref.read(watchProximitySensorUsecaseProvider);
    _watchGyroscopeUsecase = ref.read(watchGyroscopeSensorUsecaseProvider);

    ref.onDispose(() {
      _cancelSubscriptions();
      _themeDebounceTimer?.cancel();
    });

    // Automatically start listening when the VM is initialized
    Future.microtask(() => startListening());

    return const SensorsState();
  }

  void startListening() {
    if (state.status == SensorsStatus.listening) return;

    state = state.copyWith(
      status: SensorsStatus.listening,
      resetError: true,
    );

    _lightSub ??= _watchLightUsecase().listen(
      (reading) {
        state = state.copyWith(lux: reading.lux);
        _handleThemeSwitching(reading.lux);
      },
      onError: (error) {
        debugPrint('Light Sensor Error: $error');
        state = state.copyWith(
          status: SensorsStatus.error,
          errorMessage: error.toString(),
        );
      },
    );

    _proximitySub ??= _watchProximityUsecase().listen(
      (reading) {
        state = state.copyWith(
          isNear: reading.isNear,
          proximityRaw: reading.rawValue,
        );
      },
      onError: (error) {
        debugPrint('Proximity Sensor Error: $error');
        state = state.copyWith(
          status: SensorsStatus.error,
          errorMessage: error.toString(),
        );
      },
    );

    _gyroSub ??= _watchGyroscopeUsecase().listen(
      (reading) {
        state = state.copyWith(
          x: reading.x,
          y: reading.y,
          z: reading.z,
        );
      },
      onError: (error) {
        debugPrint('Gyroscope Sensor Error: $error');
        state = state.copyWith(
          status: SensorsStatus.error,
          errorMessage: error.toString(),
        );
      },
    );
  }

  void _handleThemeSwitching(int currentLux) {
    final targetTheme = currentLux < _luxThreshold ? ThemeMode.dark : ThemeMode.light;

    // If already in target theme, cancel any pending switch
    if (state.themeMode == targetTheme) {
      _themeDebounceTimer?.cancel();
      _themeDebounceTimer = null;
      return;
    }

    // Start timer if not already running for this target
    _themeDebounceTimer ??= Timer(_themeSwitchDelay, () {
      state = state.copyWith(themeMode: targetTheme);
      _themeDebounceTimer = null;
    });
  }

  void stopListening() {
    _cancelSubscriptions();
    state = state.copyWith(status: SensorsStatus.idle);
  }

  void _cancelSubscriptions() {
    _lightSub?.cancel();
    _proximitySub?.cancel();
    _gyroSub?.cancel();
    _lightSub = null;
    _proximitySub = null;
    _gyroSub = null;
  }
}
