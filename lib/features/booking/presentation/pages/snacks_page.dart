import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/features/booking/presentation/state/booking_state.dart';
import 'package:cineghar/features/booking/presentation/viewmodel/booking_viewmodel.dart';
import 'package:cineghar/features/booking/presentation/widgets/snacks_step.dart';

class SnacksPage extends ConsumerWidget {
  const SnacksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingViewModelProvider);
    final vm = ref.read(bookingViewModelProvider.notifier);
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    final double horizontalPadding = isTablet ? 40.0 : 16.0;

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
                  child: _buildTopBar(context, isTablet),
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
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Stack(
                      children: [
                        // Main content
                        SingleChildScrollView(
                          padding: EdgeInsets.all(isTablet ? 32 : 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SnacksStep(),
                              SizedBox(height: isTablet ? 100 : 80), // Extra padding for sticky button
                            ],
                          ),
                        ),
                        
                        // Sticky button at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(isTablet ? 24 : 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(isTablet ? 28 : 24),
                                bottomRight: Radius.circular(isTablet ? 28 : 24),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              height: isTablet ? 56 : 48,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                                boxShadow: AppColors.buttonShadow,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => vm.goToCheckout(),
                                  borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_forward,
                                          size: isTablet ? 24 : 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: isTablet ? 12 : 8),
                                        Text(
                                          "Continue to Checkout",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: isTablet ? 18 : 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTopBar(BuildContext context, bool isTablet) {
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
              "Choose Snacks",
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
