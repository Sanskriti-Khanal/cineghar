import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/seat_entity.dart';
import '../../providers/booking_providers.dart';
import '../../providers/seat_selection_provider.dart';
import '../../providers/simple_seat_hold_provider.dart';
import 'screen_widget.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class SeatsStep extends StatelessWidget {
  final String? hallId;
  final String? dateKey;
  final String? showtime;
  final Function(String) onSeatTap;
  final VoidCallback? onContinue;

  const SeatsStep({
    super.key,
    required this.hallId,
    required this.dateKey,
    required this.showtime,
    required this.onSeatTap,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we have all required data
    if (hallId == null || dateKey == null || showtime == null) {
      return const Center(
        child: Text(
          "Missing booking information", 
          style: TextStyle(color: Colors.black)
        ),
      );
    }

    return MinimalSeatsStep(
      hallId: hallId!,
      dateKey: dateKey!,
      showtime: showtime!,
      onSeatTap: onSeatTap,
      onContinue: onContinue,
    );
  }
}

class MinimalSeatsStep extends StatelessWidget {
  final String hallId;
  final String dateKey;
  final String showtime;
  final Function(String) onSeatTap;
  final VoidCallback? onContinue;

  const MinimalSeatsStep({
    super.key,
    required this.hallId,
    required this.dateKey,
    required this.showtime,
    required this.onSeatTap,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final seatsState = ref.watch(seatsProvider((hallId: hallId, dateKey: dateKey, showtimeId: showtime)));

        return Container(
          color: Colors.white,
          child: seatsState.when(
            data: (seatRows) {
              return SeatSelectionContent(
                hallId: hallId,
                dateKey: dateKey,
                showtime: showtime,
                seatRows: seatRows,
                onSeatTap: onSeatTap,
                onContinue: onContinue,
              );
            },
            error: (error, stackTrace) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: const ScreenWidget(),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          "Error loading seats: ${error.toString()}",
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: const ScreenWidget(),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class SeatSelectionContent extends StatelessWidget {
  final String hallId;
  final String dateKey;
  final String showtime;
  final List<List<SeatEntity>> seatRows;
  final Function(String) onSeatTap;
  final VoidCallback? onContinue;

  const SeatSelectionContent({
    super.key,
    required this.hallId,
    required this.dateKey,
    required this.showtime,
    required this.seatRows,
    required this.onSeatTap,
    this.onContinue,
  });

  void _handleSeatTap(WidgetRef ref, String seatId, Set<String> selectedSeats) {
    // This is handled by the parent ViewModel now
  }

  void _holdSelectedSeats(WidgetRef ref, Set<String> selectedSeats) {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        const SnackBar(
          content: Text('Please select seats to hold'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(
        content: Text('Seats held for 2 hours! ${selectedSeats.join(', ')}'),
        backgroundColor: Colors.amber,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'View Held',
          textColor: Colors.white,
          onPressed: () {
            // Could show a dialog with held seats info
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedSeats = ref.watch(selectedSeatsProvider);
        final seatHolds = ref.watch(simpleSeatHoldProvider);

        // Transform seats with selection and hold state
        final transformedSeats = seatRows.map((row) {
          return row.map((seat) {
            final isSelected = selectedSeats.contains(seat.id);
            final hold = seatHolds[seat.id];
            final isHeld = hold != null && !hold.isExpired;
            
            SeatStatus newStatus;
            if (isSelected) {
              newStatus = SeatStatus.selected;
            } else if (isHeld) {
              newStatus = SeatStatus.hold;
            } else {
              newStatus = seat.status;
            }
            
            return seat.copyWith(status: newStatus);
          }).toList();
        }).toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Screen
            Container(
              margin: const EdgeInsets.all(16),
              child: const ScreenWidget(),
            ),
            
            // Seat Map - Now with proper layout constraints
            Flexible(
              flex: 3,
              fit: FlexFit.loose,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: transformedSeats.isEmpty
                    ? const Center(
                        child: Text(
                          "No seats available",
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : _SimpleSeatMap(
                        rows: transformedSeats,
                        onSeatTap: (seatId) {
                          onSeatTap(seatId);
                        },
                      ),
              ),
            ),
            
            // Cinema Legend
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Container(
                margin: const EdgeInsets.all(16),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const _SimpleLegendItem(imagePath: 'assets/images/seats/seat_available.png', label: 'Available'),
                      const _SimpleLegendItem(imagePath: 'assets/images/seats/seat_selected.png', label: 'Selected'),
                      const _SimpleLegendItem(imagePath: 'assets/images/seats/seat_booked.png', label: 'Booked'),
                      const _SimpleLegendItem(
                        imagePath: 'assets/images/seats/seat_hold.png', 
                        label: 'On Hold',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Booking Summary
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selected: ${selectedSeats.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _holdSelectedSeats(ref, selectedSeats),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const Text('Hold', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedSeats.isNotEmpty ? onContinue : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const Text('Continue', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SimpleLegendItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final Color? colorFilter;
  final double opacity;

  const _SimpleLegendItem({
    required this.imagePath,
    required this.label,
    this.colorFilter,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: opacity,
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            color: colorFilter,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SimpleSeatMap extends StatelessWidget {
  final List<List<SeatEntity>> rows;
  final Function(String) onSeatTap;

  const _SimpleSeatMap({
    required this.rows,
    required this.onSeatTap,
  });

  Widget _getSeatImage(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return Image.asset('assets/images/seats/seat_available.png', fit: BoxFit.contain);
      case SeatStatus.selected:
        return Image.asset('assets/images/seats/seat_selected.png', fit: BoxFit.contain);
      case SeatStatus.hold:
        return Image.asset('assets/images/seats/seat_hold.png', fit: BoxFit.contain);
      case SeatStatus.booked:
      case SeatStatus.paid:
        return Image.asset('assets/images/seats/seat_booked.png', fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: row.map((seat) {
                    return GestureDetector(
                      onTap: () {
                        if (seat.status == SeatStatus.available || 
                            seat.status == SeatStatus.selected ||
                            seat.status == SeatStatus.hold) {
                          onSeatTap(seat.id);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: 32,
                        height: 32,
                        child: _getSeatImage(seat.status),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
