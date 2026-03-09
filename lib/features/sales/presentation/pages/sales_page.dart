import 'package:cineghar/features/sales/presentation/providers/sales_providers.dart';
import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/features/sales/presentation/state/sales_state.dart';
import 'package:cineghar/features/sales/presentation/viewmodel/sales_viewmodel.dart';
import 'package:cineghar/features/sales/domain/entities/offer_entity.dart';
import 'package:cineghar/features/booking/presentation/viewmodel/booking_viewmodel.dart';
import 'package:cineghar/features/movies/presentation/pages/all_movies_page.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  @override
  void initState() {
    super.initState();
    // Assuming the view model might need manual triggering if not already loaded
    // Future.microtask(() => ref.read(salesViewModelProvider.notifier).fetchOffers());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesViewModelProvider);
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    final double horizontalPadding = isTablet ? 40.0 : 16.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sales & Offers',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: isTablet ? 40 : 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              isTablet ? 40 : 32,
                              horizontalPadding,
                              24,
                            ),
                            child: _buildHowToAvailOffersSection(primaryColor, isTablet),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            child: Text(
                              'Featured Offers',
                              style: TextStyle(
                                fontSize: isTablet ? 28 : 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 16),
                        ),
                        _buildOffersList(state, isTablet, horizontalPadding, primaryColor),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 40),
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

  Widget _buildHowToAvailOffersSection(Color primaryColor, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to Avail Offers',
          style: TextStyle(
            fontSize: isTablet ? 28 : 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Redeeming CineGhar offers is simple and seamless, whether you book online or at the theater.',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            if (isTablet || constraints.maxWidth > 600) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildStepCard('Step 1', 'Choose an offer', 'Browse Sales & Offers and pick any active promotion that fits your movie night.', Icons.loyalty_outlined, primaryColor)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStepCard('Step 2', 'Apply while booking', 'Enter the offer code during checkout to apply it directly to your tickets or snack combos.', Icons.confirmation_number_outlined, primaryColor)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStepCard('Step 3', 'Enjoy & earn', 'Complete your visit and continue to earn loyalty points on top of your redeemed offers.', Icons.stars_rounded, primaryColor)),
                ],
              );
            }
            return Column(
              children: [
                _buildStepCard('Step 1', 'Choose an offer', 'Browse Sales & Offers and pick any active promotion that fits your movie night.', Icons.loyalty_outlined, primaryColor, isTablet: isTablet),
                const SizedBox(height: 16),
                _buildStepCard('Step 2', 'Apply while booking', 'Enter the offer code during checkout to apply it directly to your tickets or snack combos.', Icons.confirmation_number_outlined, primaryColor, isTablet: isTablet),
                const SizedBox(height: 16),
                _buildStepCard('Step 3', 'Enjoy & earn', 'Complete your visit and continue to earn loyalty points on top of your redeemed offers.', Icons.stars_rounded, primaryColor, isTablet: isTablet),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStepCard(String step, String title, String description, IconData icon, Color primaryColor, {bool isTablet = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: isTablet ? 15 : 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersList(SalesState state, bool isTablet, double horizontalPadding, Color primaryColor) {
    if (state.status == SalesStatus.loading) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (state.status == SalesStatus.error) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'Failed to load featured offers',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.read(salesViewModelProvider.notifier).fetchOffers();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Retry'),
                )
              ],
            ),
          ),
        ),
      );
    }

    if (state.offers.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  'No active offers available right now.\nCheck back later!',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: isTablet 
        ? SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildOfferCard(state.offers[index], primaryColor, isTablet),
              childCount: state.offers.length,
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildOfferCard(state.offers[index], primaryColor, isTablet),
              ),
              childCount: state.offers.length,
            ),
          ),
    );
  }

  Widget _buildOfferCard(SalesOfferEntity offer, Color primaryColor, bool isTablet) {
    final bool isPercentage = offer.type == 'percentage_discount';
    final String discountValue = isPercentage
        ? '${offer.discountPercent?.toStringAsFixed(0) ?? ''}% OFF'
        : 'NPR ${offer.discountAmount?.toStringAsFixed(0) ?? ''} OFF';

    return GestureDetector(
      onTap: () {
        // Preset the offer code in BookingViewModel
        ref.read(bookingViewModelProvider.notifier).applyOfferCode(offer.code);
        
        // Notify user with a snackbar for positive feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Offer ${offer.code} applied! Choose a movie to continue.'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Redirect to Choose Movie page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllMoviesPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              // Left Accent Strip matching the modern theme
              Container(
                width: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        discountValue,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        _getOfferIcon(offer),
                        color: Colors.white70,
                        size: 28,
                      )
                    ],
                  ),
                ),
              ),
              
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        offer.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offer.description ?? 'Use code at checkout to get discount.',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'CODE: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              offer.code.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  IconData _getOfferIcon(SalesOfferEntity offer) {
    final name = offer.name.toLowerCase();
    final desc = (offer.description ?? '').toLowerCase();

    if (name.contains('snack') || name.contains('combo') || name.contains('food') || 
        desc.contains('popcorn') || desc.contains('drink')) {
      return Icons.fastfood_rounded;
    }
    
    if (name.contains('ticket') || name.contains('show') || name.contains('movie')) {
      return Icons.confirmation_number_rounded;
    }
    
    if (name.contains('vip') || name.contains('premiere') || name.contains('gold')) {
      return Icons.stars_rounded;
    }
    
    if (name.contains('birthday') || desc.contains('celebrate')) {
      return Icons.cake_rounded;
    }

    return Icons.discount_rounded;
  }
}
