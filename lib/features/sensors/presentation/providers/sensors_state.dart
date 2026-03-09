import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SensorsStatus { idle, listening, error }

class SensorsState extends Equatable {
  final SensorsStatus status;
  final int lux;
  final bool isNear;
  final int proximityRaw;
  final double x;
  final double y;
  final double z;
  final ThemeMode themeMode;
  final String? errorMessage;

  const SensorsState({
    this.status = SensorsStatus.idle,
    this.lux = 0,
    this.isNear = false,
    this.proximityRaw = 0,
    this.x = 0,
    this.y = 0,
    this.z = 0,
    this.themeMode = ThemeMode.light,
    this.errorMessage,
  });

  SensorsState copyWith({
    SensorsStatus? status,
    int? lux,
    bool? isNear,
    int? proximityRaw,
    double? x,
    double? y,
    double? z,
    ThemeMode? themeMode,
    String? errorMessage,
    bool resetError = false,
  }) {
    return SensorsState(
      status: status ?? this.status,
      lux: lux ?? this.lux,
      isNear: isNear ?? this.isNear,
      proximityRaw: proximityRaw ?? this.proximityRaw,
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      themeMode: themeMode ?? this.themeMode,
      errorMessage: resetError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        lux,
        isNear,
        proximityRaw,
        x,
        y,
        z,
        themeMode,
        errorMessage,
      ];
}

