import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple seat hold data structure
class SimpleSeatHold {
  final String seatId;
  final DateTime createdAt;
  final DateTime expiresAt;

  SimpleSeatHold({
    required this.seatId,
    required this.createdAt,
    required this.expiresAt,
  });

  factory SimpleSeatHold.create(String seatId) {
    final now = DateTime.now();
    return SimpleSeatHold(
      seatId: seatId,
      createdAt: now,
      expiresAt: now.add(const Duration(hours: 2)),
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
}

// Provider for managing seat holds
final simpleSeatHoldProvider = NotifierProvider<SimpleSeatHoldNotifier, Map<String, SimpleSeatHold>>(SimpleSeatHoldNotifier.new);

class SimpleSeatHoldNotifier extends Notifier<Map<String, SimpleSeatHold>> {
  Timer? _cleanupTimer;

  @override
  Map<String, SimpleSeatHold> build() {
    // Disable automatic cleanup timer to prevent frequent rebuilds
    // _startCleanupTimer();
    return <String, SimpleSeatHold>{};
  }

  void _startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _cleanupExpiredHolds();
    });
  }

  void _cleanupExpiredHolds() {
    final currentHolds = state;
    final expiredHolds = <String>[];
    
    for (final entry in currentHolds.entries) {
      if (entry.value.isExpired) {
        expiredHolds.add(entry.key);
      }
    }
    
    if (expiredHolds.isNotEmpty) {
      final newHolds = Map<String, SimpleSeatHold>.from(currentHolds);
      for (final key in expiredHolds) {
        newHolds.remove(key);
      }
      state = newHolds;
    }
  }

  bool holdSeat(String seatId) {
    final currentHolds = state;
    final existingHold = currentHolds[seatId];
    if (existingHold != null && !existingHold.isExpired) {
      return false; // Seat is already held
    }

    final newHold = SimpleSeatHold.create(seatId);
    state = {...currentHolds, seatId: newHold};
    return true;
  }

  bool releaseHold(String seatId) {
    final currentHolds = state;
    if (currentHolds.containsKey(seatId)) {
      final newHolds = Map<String, SimpleSeatHold>.from(currentHolds);
      newHolds.remove(seatId);
      state = newHolds;
      return true;
    }
    return false;
  }

  SimpleSeatHold? getHold(String seatId) {
    final currentHolds = state;
    final hold = currentHolds[seatId];
    // Don't automatically cleanup during read to prevent state updates
    return hold;
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
  }
}

class SimpleSeatHoldManager {
  static bool holdSeat(WidgetRef ref, String seatId) {
    return ref.read(simpleSeatHoldProvider.notifier).holdSeat(seatId);
  }

  static bool releaseHold(WidgetRef ref, String seatId) {
    return ref.read(simpleSeatHoldProvider.notifier).releaseHold(seatId);
  }

  static SimpleSeatHold? getHold(WidgetRef ref, String seatId) {
    return ref.read(simpleSeatHoldProvider.notifier).getHold(seatId);
  }
}
