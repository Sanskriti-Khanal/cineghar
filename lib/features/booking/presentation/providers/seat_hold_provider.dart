import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/seat_hold_entity.dart';

// Provider for managing seat holds
final seatHoldProvider = StateProvider<Map<String, SeatHoldEntity>>((ref) => {});

class SeatHoldManager {
  static Timer? _cleanupTimer;

  static void startCleanupTimer(WidgetRef ref) {
    // Clean up expired holds every 30 seconds
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _cleanupExpiredHolds(ref);
    });
  }

  static void _cleanupExpiredHolds(WidgetRef ref) {
    final currentHolds = ref.read(seatHoldProvider);
    final expiredHolds = <String>[];
    
    for (final entry in currentHolds.entries) {
      if (entry.value.isExpired) {
        expiredHolds.add(entry.key);
      }
    }
    
    if (expiredHolds.isNotEmpty) {
      final newHolds = Map<String, SeatHoldEntity>.from(currentHolds);
      for (final key in expiredHolds) {
        newHolds.remove(key);
      }
      ref.read(seatHoldProvider.notifier).state = newHolds;
    }
  }

  static bool holdSeat(WidgetRef ref, String seatId, {String? userId}) {
    final currentHolds = ref.read(seatHoldProvider);
    // Check if seat is already held or expired
    final existingHold = currentHolds[seatId];
    if (existingHold != null && !existingHold.isExpired) {
      return false; // Seat is already held
    }

    // Create new hold
    final newHold = SeatHoldEntity.create(seatId: seatId, userId: userId);
    ref.read(seatHoldProvider.notifier).state = {...currentHolds, seatId: newHold};
    return true;
  }

  static bool releaseHold(WidgetRef ref, String seatId) {
    final currentHolds = ref.read(seatHoldProvider);
    if (currentHolds.containsKey(seatId)) {
      final newHolds = Map<String, SeatHoldEntity>.from(currentHolds);
      newHolds.remove(seatId);
      ref.read(seatHoldProvider.notifier).state = newHolds;
      return true;
    }
    return false;
  }

  static SeatHoldEntity? getHold(WidgetRef ref, String seatId) {
    final currentHolds = ref.read(seatHoldProvider);
    final hold = currentHolds[seatId];
    if (hold != null && hold.isExpired) {
      // Remove expired hold and return null
      final newHolds = Map<String, SeatHoldEntity>.from(currentHolds);
      newHolds.remove(seatId);
      ref.read(seatHoldProvider.notifier).state = newHolds;
      return null;
    }
    return hold;
  }

  static void dispose() {
    _cleanupTimer?.cancel();
  }
}
