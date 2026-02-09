import 'package:flutter/material.dart';
import '../../../domain/entities/seat_entity.dart';
import 'seat_widget.dart';

class SeatRowWidget extends StatelessWidget {
  final List<SeatEntity> seats;
  final double padding;
  final Function(String) onSeatTap;

  const SeatRowWidget({
    super.key,
    required this.seats,
    required this.padding,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: seats.map((seat) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: SeatWidget(seat: seat, onTap: onSeatTap),
            );
          }).toList(),
        ),
      ),
    );
  }
}
