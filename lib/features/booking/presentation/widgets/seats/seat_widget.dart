import 'package:flutter/material.dart';
import '../../../domain/entities/seat_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class SeatWidget extends StatelessWidget {
  final SeatEntity seat;
  final Function(String seatId) onTap;

  const SeatWidget({
    super.key,
    required this.seat,
    required this.onTap,
  });

  void _handleTap() {
    if (seat.status == SeatStatus.booked) {
      return; // Can't interact with booked seats
    }
    
    if (seat.status == SeatStatus.hold) {
      // Show hold information
      _showHoldInfo();
      return;
    }
    
    onTap(seat.id);
  }

  void _showHoldInfo() {
    // This would need context, so we'll handle it differently
    // For now, just don't do anything on hold tap
  }

  String _getSeatImage() {
    switch (seat.status) {
      case SeatStatus.available:
        return 'assets/images/seats/seat_available.png';
      case SeatStatus.selected:
        return 'assets/images/seats/seat_selected.png';
      case SeatStatus.hold:
        return 'assets/images/seats/seat_hold.png';
      case SeatStatus.booked:
        return 'assets/images/seats/seat_booked.png';
      case SeatStatus.paid:
        return 'assets/images/seats/seat_paid.png'; // Maroon image for paid seats
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = seat.status == SeatStatus.selected;
    
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Stack(
            children: [
              Container(
                width: 28,
                height: 28,
                color: Colors.black,
              ),
              Image.asset(
                _getSeatImage(),
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
              if (isSelected)
                Container(
                  width: 28,
                  height: 28,
                  color: Colors.white.withOpacity(0.3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}