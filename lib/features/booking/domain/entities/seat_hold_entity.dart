import 'package:equatable/equatable.dart';

class SeatHoldEntity extends Equatable {
  final String seatId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? userId; // Optional: which user is holding the seat

  const SeatHoldEntity({
    required this.seatId,
    required this.createdAt,
    required this.expiresAt,
    this.userId,
  });

  factory SeatHoldEntity.create({
    required String seatId,
    String? userId,
  }) {
    final now = DateTime.now();
    return SeatHoldEntity(
      seatId: seatId,
      createdAt: now,
      expiresAt: now.add(const Duration(hours: 2)), // 2 hours TTL
      userId: userId,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Duration get timeRemaining {
    final now = DateTime.now();
    if (isExpired) return Duration.zero;
    return expiresAt.difference(now);
  }

  String get timeRemainingText {
    final remaining = timeRemaining;
    if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}m ${remaining.inSeconds % 60}s';
    } else {
      return '${remaining.inSeconds}s';
    }
  }

  SeatHoldEntity copyWith({
    String? seatId,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? userId,
  }) {
    return SeatHoldEntity(
      seatId: seatId ?? this.seatId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [seatId, createdAt, expiresAt, userId];
}