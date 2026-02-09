import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';
import 'package:cineghar/features/sensors/presentation/providers/sensors_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/core/utils/snackbar_utils.dart';
import 'package:cineghar/features/booking/presentation/state/booking_state.dart';
import 'package:cineghar/features/booking/presentation/viewmodel/booking_viewmodel.dart';
import 'package:cineghar/features/booking/presentation/widgets/city_step.dart';
import 'package:cineghar/features/booking/presentation/widgets/hall_step.dart';
import 'package:cineghar/features/booking/presentation/widgets/datetime_step.dart';
import 'package:cineghar/features/booking/presentation/widgets/seats/seats_step.dart';
import 'package:cineghar/features/booking/presentation/pages/snacks_page.dart';
import 'package:cineghar/features/booking/presentation/pages/checkout_page.dart';
import 'dart:math' as math;

class BookingPage extends ConsumerStatefulWidget {
  final String movieId;
  final String movieTitle;

  const BookingPage({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  bool _isShaken = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingViewModelProvider);
    final vm = ref.read(bookingViewModelProvider.notifier);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    final double horizontalPadding = isTablet ? 40.0 : 16.0;

    // Shake Detection Logic - use listen instead of watch to avoid rapid rebuilds
    ref.listen(sensorsViewModelProvider, (previous, next) {
      if (!_isShaken) {
        final double magnitude = math.sqrt(
          next.x * next.x +
          next.y * next.y +
          next.z * next.z
        );
        if (magnitude > 5.0) { // Threshold for twist/shake - 5.0 rad/s
          if (mounted && !_isShaken) {
            setState(() {
              _isShaken = true;
            });
            SnackbarUtils.showSuccess(context, "Shake to book yoo!");
          }
        }
      }
    });

    // Ensure movieId is set in the viewmodel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.movieId != widget.movieId) {
        vm.setMovieId(widget.movieId);
      }
    });

    // Handle navigation to separate pages
    if (state.step == BookingStep.snacks) {
      return SnacksPage();
    }
    
    if (state.step == BookingStep.checkout) {
      return CheckoutPage(movieId: widget.movieId, movieTitle: widget.movieTitle);
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isTablet ? 16 : 12,
                  ),
                  child: _buildTopBar(context, widget.movieTitle, isTablet, state),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: isTablet ? 20 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Black background instead of AppColors.surface
                      borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isTablet ? 32 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.step == BookingStep.city)
                            CityStep(selectedCity: state.city, onSelect: vm.selectCity),
                          if (state.step == BookingStep.hall)
                            HallStep(
                              city: state.city,
                              onSelect: (hallId, hallName) => vm.selectHall(hallId: hallId, hallName: hallName),
                            ),
                          if (state.step == BookingStep.dateTime)
                            DateTimeStep(
                              selectedDate: state.dateKey,
                              selectedTime: state.showtime,
                              hallId: state.hallId,
                              onSelectDate: vm.selectDateKey,
                              onSelectTime: vm.selectShowtime,
                            ),
                          if (state.step == BookingStep.seats)
                            SeatsStep(
                              hallId: state.hallId,
                              dateKey: state.dateKey,
                              showtime: state.showtime?.id,
                              onSeatTap: vm.toggleSeat,
                              onContinue: () => vm.goToSnacks(),
                            ),
                          if (state.errorMessage != null)
                            Container(
                              margin: EdgeInsets.only(top: isTablet ? 20 : 16),
                              padding: EdgeInsets.all(isTablet ? 16 : 12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.error.withOpacity(0.3)),
                              ),
                              child: Text(
                                state.errorMessage!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          
                          if (_isShaken)
                            Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "Shake to book yoo!",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Trigger booking or next step
                                        if (state.step == BookingStep.seats && state.selectedSeats.isNotEmpty) {
                                          vm.goToSnacks();
                                        } else if (state.step != BookingStep.seats) {
                                           // Provide feedback if not ready
                                           SnackbarUtils.showInfo(context, "Please complete current selection first!");
                                        } else {
                                          SnackbarUtils.showInfo(context, "Select seats first!");
                                        }
                                      },
                                      child: const Text("Book Now"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String title, bool isTablet, BookingState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: isTablet ? 28 : 24,
              ),
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 28 : 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
