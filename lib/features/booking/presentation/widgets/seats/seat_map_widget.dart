import 'package:flutter/material.dart';
import '../../../domain/entities/seat_entity.dart';
import 'seat_widget.dart';

class SeatMapWidget extends StatelessWidget {
  final List<List<SeatEntity>> rows;
  final Function(String) onSeatTap;

  const SeatMapWidget({
    super.key,
    required this.rows,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    
    return Container(
      color: Colors.black,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: rows.length,
        itemBuilder: (context, rowIndex) {
          final seats = rows[rowIndex];
          
          return Container(
            key: ValueKey('row_$rowIndex'),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row letter
                Container(
                  key: ValueKey('row_letter_$rowIndex'),
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + rowIndex), // A, B, C, etc.
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Seats - using a flexible row layout
                Expanded(
                  child: _SeatRowBuilder(
                    key: ValueKey('seat_row_$rowIndex'),
                    seats: seats,
                    onSeatTap: onSeatTap,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SeatRowBuilder extends StatelessWidget {
  final List<SeatEntity> seats;
  final Function(String) onSeatTap;

  const _SeatRowBuilder({
    super.key,
    required this.seats,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: seats.asMap().entries.map((entry) {
        final index = entry.key;
        final seat = entry.value;
        return Padding(
          key: ValueKey('seat_padding_${seat.id}_$index'),
          padding: const EdgeInsets.all(2),
          child: SeatWidget(
            key: ValueKey('seat_widget_${seat.id}_$index'),
            seat: seat,
            onTap: onSeatTap,
          ),
        );
      }).toList(),
    );
  }
}