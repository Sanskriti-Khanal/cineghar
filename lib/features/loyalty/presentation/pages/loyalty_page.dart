import 'package:cineghar/features/loyalty/presentation/providers/loyalty_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/features/loyalty/presentation/state/loyalty_state.dart';
import 'package:cineghar/features/loyalty/presentation/viewmodel/loyalty_viewmodel.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import '../../domain/entities/loyalty_entity.dart';
import '../../domain/entities/reward_entity.dart';

class LoyaltyPage extends ConsumerWidget {
  const LoyaltyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loyaltyViewModelProvider);
    final theme = Theme.of(context);
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
          'Rewards Centre',
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
                    child: RefreshIndicator(
                      onRefresh: () => ref.read(loyaltyViewModelProvider.notifier).load(),
                      child: state.status == LoyaltyStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : state.status == LoyaltyStatus.error
                              ? Center(child: Text(state.errorMessage ?? 'Error loading loyalty info'))
                              : _buildContent(context, state, isTablet, horizontalPadding),
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

  Widget _buildContent(BuildContext context, LoyaltyState state, bool isTablet, double horizontalPadding) {
    final info = state.loyaltyInfo;
    if (info == null) return const Center(child: Text('No loyalty info found'));

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        isTablet ? 40 : 32,
        horizontalPadding,
        40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPointsCard(context, info),
          const SizedBox(height: 24),
          _buildStatsRow(context, info),
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'How to earn more points'),
          const SizedBox(height: 16),
          _buildEarnMoreSection(context),
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Available Rewards'),
          const SizedBox(height: 8),
          const Text(
            'Redeem your points for exclusive rewards and benefits. These rewards are configured in the admin dashboard.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _buildRewardsList(context, state.rewards, info.loyaltyPoints),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context, LoyaltyInfoEntity info) {
    final targetPoints = 3000;
    final progress = (info.loyaltyPoints / targetPoints).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${info.loyaltyPoints} pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFD700), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${info.membershipTier} member',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Text(
            info.loyaltyPoints >= targetPoints 
                ? "You've reached the premiere ticket milestone!" 
                : "You're ${targetPoints - info.loyaltyPoints} pts away from a free premiere ticket.",
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            '${info.pointsMultiplier}x on tickets',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, LoyaltyInfoEntity info) {
    return Row(
      children: [
        Expanded(child: _buildStatItem(context, 'This month', info.thisMonthPoints.toString(), Icons.calendar_today_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem(context, 'Tickets booked', info.ticketsBooked.toString(), Icons.confirmation_number_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem(context, 'Rewards redeemed', info.rewardsRedeemed.toString(), Icons.card_giftcard_outlined)),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF800000)),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildEarnMoreSection(BuildContext context) {
    final earnMethods = [
      {
        'title': 'Book movie tickets',
        'subtitle': 'Earn 5 pts for every ticket you book.',
        'icon': Icons.movie_outlined,
      },
      {
        'title': 'Snacks & combos',
        'subtitle': 'Collect extra pts when you buy popcorn, drinks, and special combo deals.',
        'icon': Icons.fastfood_outlined,
      },
      {
        'title': 'Streaming & on-demand',
        'subtitle': 'Earn points for every completed movie on the CineGhar web platform.',
        'icon': Icons.tv_outlined,
      },
      {
        'title': 'Referrals & milestones',
        'subtitle': 'Invite friends and unlock referral bonuses and milestone achievements.',
        'icon': Icons.group_add_outlined,
      },
    ];

    return Column(
      children: earnMethods.map((method) => _buildEarnMethodItem(context, method)).toList(),
    );
  }

  Widget _buildEarnMethodItem(BuildContext context, Map<String, dynamic> method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF800000).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(method['icon'] as IconData, color: const Color(0xFF800000), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  method['subtitle'] as String,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsList(BuildContext context, List<LoyaltyRewardEntity> rewards, int currentPoints) {
    if (rewards.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Column(
          children: [
            Icon(Icons.card_giftcard, color: Colors.grey, size: 40),
            SizedBox(height: 12),
            Text('No rewards available at the moment.', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final bool isAvailable = currentPoints >= reward.pointsRequired;
        final int pointsRemaining = reward.pointsRequired - currentPoints;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
            ],
            border: isAvailable 
                ? Border.all(color: Colors.amber.withOpacity(0.3), width: 1.5) 
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isAvailable ? Colors.amber[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.card_giftcard, 
                  color: isAvailable ? Colors.amber : Colors.grey, 
                  size: 30
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.title, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 15,
                        color: isAvailable ? AppColors.textPrimary : Colors.black54,
                      )
                    ),
                    const SizedBox(height: 4),
                    if (isAvailable)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Ready to redeem',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Text(
                        '$pointsRemaining pts remaining',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${reward.pointsRequired}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: isAvailable ? const Color(0xFF800000) : Colors.grey, 
                      fontSize: 18
                    ),
                  ),
                  const Text('pts', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
