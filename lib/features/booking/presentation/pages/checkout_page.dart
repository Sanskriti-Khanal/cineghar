import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/core/utils/snackbar_utils.dart';
import 'package:cineghar/features/booking/presentation/state/booking_state.dart';
import 'package:cineghar/features/booking/presentation/viewmodel/booking_viewmodel.dart';
import 'package:cineghar/features/orders/presentation/pages/order_success_page.dart';
import 'package:cineghar/app/routes/app_routes.dart';
import 'package:cineghar/features/sensors/presentation/providers/sensors_providers.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final String movieId;
  final String movieTitle;

  const CheckoutPage({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> with WidgetsBindingObserver {
  bool _isConfirming = false;
  bool _isShaken = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed) {
      final state = ref.read(bookingViewModelProvider);
      if (state.pidx != null && state.purchaseOrderId != null && state.status == BookingStatus.redirecting && !_isConfirming) {
        _isConfirming = true;
        _verifyKhaltiPayment();
      }
    }
  }

  Future<void> _verifyKhaltiPayment() async {
    final vm = ref.read(bookingViewModelProvider.notifier);
    final order = await vm.confirmPayment();
    if (mounted) {
      _isConfirming = false;
      if (order != null) {
        SnackbarUtils.showSuccess(context, "Payment successful!");
        AppRoutes.pushAndRemoveUntil(context, OrderSuccessPage(order: order));
      } else {
        final state = ref.read(bookingViewModelProvider);
        if (state.errorMessage != null) {
          SnackbarUtils.showError(context, state.errorMessage!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingViewModelProvider);
    final vm = ref.read(bookingViewModelProvider.notifier);
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    final double horizontalPadding = isTablet ? 40.0 : 16.0;

    // Shake Detection Logic - use listen instead of watch to avoid rapid rebuilds
    ref.listen(sensorsViewModelProvider, (previous, next) {
      if (!_isShaken && state.status != BookingStatus.redirecting && state.status != BookingStatus.loading) {
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
            SnackbarUtils.showSuccess(context, "Shake to book triggered!");
            _initiatePayment(vm, state);
          }
        }
      }
    });

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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isTablet ? 32 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: isTablet ? 32 : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Text(
                            "Review your booking details and complete payment",
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: isTablet ? 32 : 24),

                          /// BOOKING SUMMARY CARD
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isTablet ? 24 : 20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.softShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: isTablet ? 48 : 40,
                                      height: isTablet ? 48 : 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
                                      ),
                                      child: Icon(
                                        Icons.confirmation_number,
                                        size: isTablet ? 24 : 20,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: isTablet ? 16 : 12),
                                    Text(
                                      "Booking Details",
                                      style: TextStyle(
                                        fontSize: isTablet ? 20 : 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isTablet ? 20 : 16),
                                
                                _buildDetailRow(
                                  "Movie", 
                                  widget.movieTitle, 
                                  Icons.movie, 
                                  isTablet
                                ),
                                SizedBox(height: isTablet ? 12 : 8),
                                
                                _buildDetailRow(
                                  "Seats", 
                                  state.selectedSeats.join(', '), 
                                  Icons.event_seat, 
                                  isTablet
                                ),
                                SizedBox(height: isTablet ? 12 : 8),
                                
                                _buildDetailRow(
                                  "City", 
                                  state.city ?? 'Not selected', 
                                  Icons.location_city, 
                                  isTablet
                                ),
                                SizedBox(height: isTablet ? 12 : 8),
                                
                                _buildDetailRow(
                                  "Hall", 
                                  state.hallName ?? 'Not selected', 
                                  Icons.theater_comedy, 
                                  isTablet
                                ),
                                SizedBox(height: isTablet ? 12 : 8),
                                
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: isTablet ? 20 : 16,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(width: isTablet ? 12 : 8),
                                    Text(
                                      "Date & Time:",
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(width: isTablet ? 8 : 6),
                                    Expanded(
                                      child: Text(
                                        "${state.dateKey ?? 'Not selected'} at ${state.showtime?.time ?? 'Not selected'}", 
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: isTablet ? 20 : 16),
                                const Divider(),
                                SizedBox(height: isTablet ? 16 : 12),
                                
                                _priceRow("Tickets", state.ticketSubtotal, isTablet),
                                _priceRow("Snacks", state.snacksSubtotal, isTablet),
                              ],
                            ),
                          ),

                          SizedBox(height: isTablet ? 24 : 20),

                          /// DISCOUNT CARD
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isTablet ? 24 : 20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.softShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      "Discount & Offers",
                                      style: TextStyle(
                                        fontSize: isTablet ? 20 : 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isTablet ? 20 : 16),

                                Row(
                                  children: [
                                    _buildDiscountOption(
                                      "None",
                                      "none",
                                      state.discountType == "none",
                                      () => vm.selectDiscountType("none"),
                                      isTablet,
                                    ),
                                    SizedBox(width: isTablet ? 12 : 8),
                                    _buildDiscountOption(
                                      "Offer",
                                      "offer",
                                      state.discountType == "offer",
                                      () => vm.selectDiscountType("offer"),
                                      isTablet,
                                    ),
                                    SizedBox(width: isTablet ? 12 : 8),
                                    _buildDiscountOption(
                                      "Loyalty",
                                      "loyalty",
                                      state.discountType == "loyalty",
                                      () => vm.selectDiscountType("loyalty"),
                                      isTablet,
                                    ),
                                  ],
                                ),

                                SizedBox(height: isTablet ? 20 : 16),

                                if (state.discountType == "offer")
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: state.selectedOfferCode,
                                      decoration: InputDecoration(
                                        labelText: "Select Offer",
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      items: state.offers
                                          .map(
                                            (o) => DropdownMenuItem(
                                              value: o.code,
                                              child: Text(o.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: vm.selectOffer,
                                    ),
                                  ),

                                if (state.discountType == "loyalty")
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Available Points: ${state.loyaltyPoints}",
                                                style: TextStyle(
                                                  fontSize: isTablet ? 14 : 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isTablet ? 8 : 6),
                                        DropdownButtonFormField<String>(
                                          value: state.selectedRewardId,
                                          decoration: InputDecoration(
                                            labelText: "Select Reward",
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          items: state.rewards.map(
                                            (r) {
                                              final canAfford = r.pointsRequired <= state.loyaltyPoints;
                                              return DropdownMenuItem<String>(
                                                value: r.id,
                                                enabled: canAfford,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            r.title,
                                                            style: TextStyle(
                                                              fontSize: isTablet ? 14 : 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: canAfford ? AppColors.textPrimary : AppColors.textTertiary,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${r.pointsRequired} pts",
                                                            style: TextStyle(
                                                              fontSize: isTablet ? 12 : 10,
                                                              color: canAfford ? AppColors.textSecondary : AppColors.error,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (!canAfford)
                                                      Icon(
                                                        Icons.lock,
                                                        size: isTablet ? 16 : 14,
                                                        color: AppColors.error,
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: vm.selectReward,
                                        ),
                                        if (state.rewards.every((reward) => reward.pointsRequired > state.loyaltyPoints))
                                          Padding(
                                            padding: EdgeInsets.only(top: isTablet ? 8 : 6),
                                            child: Text(
                                              "You don't have enough points for any rewards",
                                              style: TextStyle(
                                                fontSize: isTablet ? 12 : 10,
                                                color: AppColors.error,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: isTablet ? 24 : 20),

                          /// TOTAL SUMMARY CARD
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isTablet ? 24 : 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withOpacity(0.05),
                                  AppColors.primary.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                              boxShadow: AppColors.softShadow,
                            ),
                            child: Column(
                              children: [
                                if (state.discountAmount > 0) ...[
                                  _priceRow("Discount", -state.discountAmount, isTablet),
                                  const Divider(),
                                ],
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Amount",
                                      style: TextStyle(
                                        fontSize: isTablet ? 22 : 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      "NPR ${state.totalAfterDiscount}",
                                      style: TextStyle(
                                        fontSize: isTablet ? 24 : 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: isTablet ? 32 : 24),

                          /// PAYMENT BUTTON
                          Container(
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
                                onTap: state.status == BookingStatus.redirecting
                                    ? null
                                    : () async {
                                        _initiatePayment(vm, state);
                                      },
                                borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (state.status == BookingStatus.redirecting) ...[
                                        SizedBox(
                                          width: isTablet ? 20 : 16,
                                          height: isTablet ? 20 : 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: isTablet ? 12 : 8),
                                      ] else ...[
                                        Icon(
                                          Icons.account_balance_wallet,
                                          size: isTablet ? 24 : 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: isTablet ? 12 : 8),
                                      ],
                                      Text(
                                        state.status == BookingStatus.redirecting || state.status == BookingStatus.loading
                                            ? "Starting Payment..."
                                            : "Pay with Khalti - NPR ${state.totalAfterDiscount}",
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
              "Checkout",
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

  Future<void> _initiatePayment(BookingViewModel vm, BookingState state) async {
    // Validate loyalty points before proceeding
    if (!vm.canProceedWithPayment()) {
      SnackbarUtils.showError(context, "You don't have enough loyalty points for this reward");
      if (mounted) setState(() => _isShaken = false);
      return;
    }
    
    final url = await vm.startPayment(
      movieId: widget.movieId,
      movieTitle: widget.movieTitle,
    );

    if (url != null && mounted) {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        SnackbarUtils.showError(context, "Could not launch payment URL");
        if (mounted) setState(() => _isShaken = false);
      }
    } else if (mounted) {
      SnackbarUtils.showError(context, "Failed to initiate payment");
      if (mounted) setState(() => _isShaken = false);
    }
  }

  Widget _buildDetailRow(String label, String value, IconData icon, bool isTablet) {
    return Row(
      children: [
        Icon(
          icon,
          size: isTablet ? 20 : 16,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: isTablet ? 12 : 8),
        Text(
          "$label:",
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: isTablet ? 8 : 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountOption(
    String label,
    String value,
    bool isSelected,
    VoidCallback onTap,
    bool isTablet,
  ) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 12,
              vertical: isTablet ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, num amount, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 6 : 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            "NPR ${amount.abs()}",
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w700,
              color: amount < 0 ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  }
