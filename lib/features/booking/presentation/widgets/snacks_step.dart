import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/features/booking/presentation/viewmodel/booking_viewmodel.dart';
import 'package:cineghar/features/booking/presentation/widgets/snack_card.dart';
import 'package:cineghar/features/booking/presentation/state/booking_state.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class SnacksStep extends ConsumerWidget {
  const SnacksStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingViewModelProvider);
    final vm = ref.read(bookingViewModelProvider.notifier);
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    
    // Debug: Check combo items
    print('SnackItems count: ${state.snackItems.length}');
    print('SnackCombos count: ${state.snackCombos.length}');
    
    // Show loading state
    if (state.status == BookingStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // Show error state
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 64 : 48,
              color: AppColors.error,
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'Failed to load snacks',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
            Text(
              state.errorMessage!,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    // Show empty state
    if (state.snackItems.isEmpty && state.snackCombos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_food,
              size: isTablet ? 64 : 48,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'No snacks available',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }
    
    // Determine responsive grid columns
    int crossAxisCount;
    if (size.shortestSide > 1200) {
      crossAxisCount = 4; // Large screens
    } else if (size.shortestSide > 600) {
      crossAxisCount = 3; // Tablet
    } else {
      crossAxisCount = 2; // Mobile
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Snacks & Beverages",
          style: TextStyle(
            fontSize: isTablet ? 32 : 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Text(
          "Enhance your movie experience with delicious treats",
          style: TextStyle(
            fontSize: isTablet ? 18 : 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),
        
        // Snack Items Section
        if (state.snackItems.isNotEmpty) ...[
          Row(
            children: [
              Container(
                width: isTablet ? 48 : 40,
                height: isTablet ? 48 : 40,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
                ),
                child: Icon(
                  Icons.fastfood,
                  size: isTablet ? 24 : 20,
                  color: AppColors.warning,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Text(
                "Individual Items",
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          
          // Grid Layout for Snack Items
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: isTablet ? 8 : 6,
              mainAxisSpacing: isTablet ? 8 : 6,
              childAspectRatio: 0.65, // More compact aspect ratio
            ),
            itemCount: state.snackItems.length,
            itemBuilder: (context, index) {
              final snack = state.snackItems[index];
              return SnackCard(
                snack: snack,
                quantity: state.snackCart[snack.id] ?? 0,
                onQuantityChanged: (quantity) {
                  vm.updateSnackQuantity(snack.id, quantity, snack.price.toInt());
                },
                isTablet: isTablet,
                isCombo: false,
              );
            },
          ),
          SizedBox(height: isTablet ? 24 : 20),
        ],
        
        // Snack Combos Section
        if (state.snackCombos.isNotEmpty) ...[
          Row(
            children: [
              Container(
                width: isTablet ? 48 : 40,
                height: isTablet ? 48 : 40,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
                ),
                child: Icon(
                  Icons.local_offer,
                  size: isTablet ? 24 : 20,
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Text(
                "Special Combos",
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          
          // Grid Layout for Snack Combos
          if (state.snackCombos.isNotEmpty)
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: isTablet ? 8 : 6,
                mainAxisSpacing: isTablet ? 8 : 6,
                childAspectRatio: 0.65, // More compact aspect ratio
              ),
              itemCount: state.snackCombos.length,
              itemBuilder: (context, index) {
                final combo = state.snackCombos[index];
                return SnackCard(
                  snack: combo,
                  quantity: state.snackCart[combo.id] ?? 0,
                  onQuantityChanged: (quantity) {
                    vm.updateSnackQuantity(combo.id, quantity, combo.price.toInt());
                  },
                  isTablet: isTablet,
                  isCombo: true,
                );
              },
            ),
          if (state.snackCombos.isNotEmpty) SizedBox(height: isTablet ? 24 : 20),
        ],
        
        // Snacks Subtotal
        if (state.snacksSubtotal > 0)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.success.withOpacity(0.05),
                  AppColors.success.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
              border: Border.all(color: AppColors.success.withOpacity(0.2)),
              boxShadow: AppColors.softShadow,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: isTablet ? 24 : 20,
                  color: AppColors.success,
                ),
                SizedBox(width: isTablet ? 12 : 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Snacks Total",
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'NPR ${state.snacksSubtotal}',
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}
