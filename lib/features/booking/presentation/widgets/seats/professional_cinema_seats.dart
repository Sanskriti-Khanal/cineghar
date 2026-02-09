import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/seat_entity.dart';
import '../../providers/seat_selection_provider.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class ProfessionalCinemaSeats extends ConsumerStatefulWidget {
  final List<List<SeatEntity>> seatRows;
  final Function(String) onSeatTap;
  final VoidCallback? onContinue;

  const ProfessionalCinemaSeats({
    super.key,
    required this.seatRows,
    required this.onSeatTap,
    this.onContinue,
  });

  @override
  ConsumerState<ProfessionalCinemaSeats> createState() => _ProfessionalCinemaSeatsState();
}

class _ProfessionalCinemaSeatsState extends ConsumerState<ProfessionalCinemaSeats>
    with TickerProviderStateMixin {
  double _zoomLevel = 1.0;
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  late AnimationController _glowAnimationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowAnimationController,
      curve: Curves.easeInOut,
    ));
    // Disable the continuous animation to prevent rendering issues
    // _glowAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowAnimationController.dispose();
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      if (_zoomLevel < 2.0) _zoomLevel += 0.2;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomLevel > 0.8) _zoomLevel -= 0.2;
    });
  }

  void _showHoldInfo(BuildContext context, SeatEntity seat) {
    if (seat.holdExpiresAt == null) return;
    
    final remaining = seat.holdExpiresAt!.difference(DateTime.now());
    if (remaining.isNegative) return; // Expired
    
    final mins = remaining.inMinutes;
    final secs = remaining.inSeconds % 60;
    final timeString = '${mins.toString().padLeft(2, '0')} mins ${secs.toString().padLeft(2, '0')} secs';
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seat ${seat.id} is currently on hold', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text('TTL expires on ${seat.holdExpiresAt!.toLocal().toString().split('.')[0]}', style: const TextStyle(color: Colors.white70)),
            Text('Remaining time: $timeString', style: const TextStyle(color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.orange.shade800,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getSeatColor(SeatEntity seat) {
    final selectedSeats = ref.watch(selectedSeatsProvider);
    final isSelected = selectedSeats.contains(seat.id);
    
    if (isSelected) {
      return Colors.orange; // Selected seats
    }
    
    switch (seat.status) {
      case SeatStatus.available:
        switch (seat.type) {
          case SeatType.standard:
            return Colors.blue.shade600; // Standard - blue
          case SeatType.premium:
            return Colors.amber.shade600; // Premium - amber
          case SeatType.vip:
            return Colors.purple.shade600; // VIP - purple
        }
      case SeatStatus.booked:
        return Colors.red.shade600; // Booked - red
      case SeatStatus.hold:
        return Colors.orange.shade400; // Hold - light orange
      case SeatStatus.paid:
        return Colors.brown.shade800; // Paid - maroon
      case SeatStatus.selected:
        return Colors.green.shade600; // Alternative selected - green
    }
  }

  double _calculateTotalPrice() {
    final selectedSeats = ref.watch(selectedSeatsProvider);
    double total = 0.0;
    
    for (final row in widget.seatRows) {
      for (final seat in row) {
        if (selectedSeats.contains(seat.id)) {
          total += seat.price;
        }
      }
    }
    
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final selectedSeats = ref.watch(selectedSeatsProvider);
    final totalPrice = _calculateTotalPrice();
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900,
            Colors.black,
            Colors.grey.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with zoom controls
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Your Seats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _zoomOut,
                      icon: Icon(Icons.zoom_out, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(_zoomLevel * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _zoomIn,
                      icon: Icon(Icons.zoom_in, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Screen indicator
          Container(
            margin: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 24),
            child: Column(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Container(
                  height: isTablet ? 50 : 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.shade300,
                        Colors.grey.shade200,
                        Colors.grey.shade100,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'SCREEN',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: isTablet ? 18 : 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Seats area with scroll
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 24),
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.8,
                maxScale: 2.0,
                scaleEnabled: true,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      // Column numbers header
                      Container(
                        margin: const EdgeInsets.only(left: 40),
                        child: Row(
                          children: List.generate(
                            widget.seatRows.first.length,
                            (index) => Container(
                              key: ValueKey('col_header_$index'),
                              width: 40 * _zoomLevel,
                              height: 30 * _zoomLevel,
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12 * _zoomLevel,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Seat rows
                      ...widget.seatRows.asMap().entries.map((entry) {
                        final rowIndex = entry.key;
                        final row = entry.value;
                        final rowLetter = String.fromCharCode(65 + rowIndex); // A, B, C, etc.
                        
                        return Container(
                          key: ValueKey('cinema_row_$rowIndex'),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row letter
                              Container(
                                key: ValueKey('row_letter_$rowIndex'),
                                width: 40 * _zoomLevel,
                                height: 40 * _zoomLevel,
                                alignment: Alignment.center,
                                child: Text(
                                  rowLetter,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16 * _zoomLevel,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              
                              // Seats in row - horizontal scroll if needed
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: _horizontalController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: row.map((seat) {
                                      final isSelected = selectedSeats.contains(seat.id);
                                      return Container(
                                        key: ValueKey('cinema_seat_${seat.id}_$rowIndex'),
                                        width: 40 * _zoomLevel,
                                        height: 40 * _zoomLevel,
                                        margin: const EdgeInsets.all(2),
                                        child: GestureDetector(
                                              onTap: () {
                                                if (seat.status == SeatStatus.hold) {
                                                  _showHoldInfo(context, seat);
                                                } else if (seat.status != SeatStatus.booked) {
                                                  widget.onSeatTap(seat.id);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: _getSeatColor(seat),
                                                  borderRadius: BorderRadius.circular(8 * _zoomLevel),
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                            color: _getSeatColor(seat).withOpacity(0.8),
                                                            blurRadius: 15 * _zoomLevel,
                                                            spreadRadius: 2 * _zoomLevel,
                                                          ),
                                                        ]
                                                      : [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.3),
                                                            blurRadius: 4,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                        ],
                                                ),
                                                child: Icon(
                                                  Icons.event_seat,
                                                  color: seat.status == SeatStatus.booked
                                                      ? Colors.grey.shade400
                                                      : Colors.white.withOpacity(0.9),
                                                  size: 20 * _zoomLevel,
                                                ),
                                              ),
                                            ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
