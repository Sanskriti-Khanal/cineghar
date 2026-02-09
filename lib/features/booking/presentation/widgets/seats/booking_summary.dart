import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/seat_entity.dart';
import '../../providers/seat_selection_provider.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class BookingSummary extends ConsumerWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onHold;

  const BookingSummary({
    super.key,
    this.onContinue,
    this.onHold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSeats = ref.watch(selectedSeatsProvider);
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;

    // Calculate totals by seat type
    final Map<String, List<String>> seatsByType = {};
    double totalPrice = 0.0;

    // Mock seat data for calculation (in real app, this would come from seat data)
    for (final seatId in selectedSeats) {
      // For demo, assume standard pricing
      // In real implementation, you'd get the actual SeatEntity objects
      final price = 10.0; // Default standard price
      totalPrice += price;
      
      seatsByType.putIfAbsent('Standard', () => []).add(seatId);
    }

    return Container(
      margin: EdgeInsets.all(isTablet ? 24 : 16),
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 12 : 8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Text(
                'Booking Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 20 : 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          SizedBox(height: isTablet ? 20 : 16),
          
          // Selected seats
          if (selectedSeats.isNotEmpty) ...[
            Text(
              'Selected Seats',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: selectedSeats.map((seatId) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 8,
                      vertical: isTablet ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                    ),
                    child: Text(
                      seatId,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 12 : 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: isTablet ? 20 : 16),
          ],
          
          // Price breakdown
          ...seatsByType.entries.map((entry) {
            final type = entry.key;
            final seats = entry.value;
            final typePrice = type == 'Standard' ? 10.0 : type == 'Premium' ? 15.0 : 25.0;
            final subtotal = seats.length * typePrice;
            
            return Padding(
              padding: EdgeInsets.only(bottom: isTablet ? 12 : 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$type (${seats.length}x)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          
          // Divider
          if (selectedSeats.isNotEmpty) ...[
            SizedBox(height: isTablet ? 16 : 12),
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            SizedBox(height: isTablet ? 16 : 12),
          ],
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          SizedBox(height: isTablet ? 24 : 20),
          
          // Action buttons
          if (selectedSeats.isNotEmpty) ...[
            Row(
              children: [
                // Hold button
                Expanded(
                  child: Container(
                    height: isTablet ? 56 : 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onHold,
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_clock,
                                color: Colors.white,
                                size: isTablet ? 20 : 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Hold Seats',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                
                // Continue button
                Expanded(
                  child: Container(
                    height: isTablet ? 56 : 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onContinue,
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: isTablet ? 20 : 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              width: double.infinity,
              height: isTablet ? 56 : 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              ),
              alignment: Alignment.center,
              child: Text(
                'Select seats to continue',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
