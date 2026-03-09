import 'package:cineghar/features/movies/presentation/providers/movies_providers.dart';
import 'package:cineghar/features/loyalty/presentation/providers/loyalty_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/features/sales/presentation/pages/sales_page.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';
import 'package:cineghar/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:cineghar/features/movies/presentation/pages/all_movies_page.dart';
import 'package:cineghar/features/movies/presentation/providers/movies_state.dart';
import 'package:cineghar/features/movies/presentation/viewmodel/movies_viewmodel.dart';
import 'package:cineghar/features/loyalty/presentation/state/loyalty_state.dart';
import 'package:cineghar/features/loyalty/presentation/viewmodel/loyalty_viewmodel.dart';
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  final PageController _movieController = PageController(viewportFraction: 0.6);
  double _currentMoviePage = 0;

  @override
  void initState() {
    super.initState();
    _bannerController.addListener(() {
      // Trigger subtle scale animation on banners
      setState(() {});
    });
    _movieController.addListener(() {
      setState(() {
        _currentMoviePage = _movieController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _movieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    final double horizontalPadding = isTablet ? 40.0 : 16.0;
    final double bannerHeight = isTablet ? 260 : 170;
    final double maxContentWidth = isTablet ? 1200 : double.infinity;

    return Stack(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isTablet ? 16 : 12,
                ),
                child: _buildTopBar(primaryColor, isTablet),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: SingleChildScrollView(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: bannerHeight - 40),
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: isTablet ? bannerHeight - 120 : bannerHeight - 80),
                                _buildNowShowingSection(
                                  primaryColor: primaryColor,
                                  isTablet: isTablet,
                                  horizontalPadding: horizontalPadding,
                                ),
                                 SizedBox(height: isTablet ? 20 : 12),
                                 _buildCurrentSalesSection(
                                   isTablet: isTablet,
                                   horizontalPadding: horizontalPadding,
                                 ),
                                 SizedBox(height: isTablet ? 20 : 12),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: horizontalPadding,
                            right: horizontalPadding,
                            child: SizedBox(
                              height: bannerHeight,
                              child: PageView.builder(
                                controller: _bannerController,
                                itemCount: 3,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentBanner = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final currentPage =
                                      _bannerController.page ?? _currentBanner.toDouble();
                                  final distance =
                                      (currentPage - index).abs().clamp(0.0, 1.0);
                                  final scale = 1.0 - (0.06 * distance);

                                  return AnimatedScale(
                                    duration: const Duration(milliseconds: 250),
                                    scale: scale,
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 250),
                                      opacity: 1.0 - (0.25 * distance),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              isTablet ? 28 : 24),
                                          boxShadow: AppColors.cardShadow,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              isTablet ? 28 : 24),
                                          child: Builder(
                                            builder: (_) {
                                              if (index == 0) {
                                                return Image.asset(
                                                  'assets/images/home_banner1.png',
                                                  fit: BoxFit.cover,
                                                );
                                              } else if (index == 1) {
                                                return Image.network(
                                                  'https://t4.ftcdn.net/jpg/02/81/07/63/360_F_281076350_HzOotmfZngtpedG18Pz5dPXbidk95pkD.jpg',
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child,
                                                      loadingProgress) {
                                                    if (loadingProgress == null) {
                                                      return child;
                                                    }
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      alignment: Alignment.center,
                                                      child:
                                                          const CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder:
                                                      (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      alignment: Alignment.center,
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                return Image.network(
                                                  'https://static.vecteezy.com/system/resources/thumbnails/001/950/057/small/now-showing-with-electric-bulbs-frame-on-red-curtain-background-free-vector.jpg',
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child,
                                                      loadingProgress) {
                                                    if (loadingProgress == null) {
                                                      return child;
                                                    }
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      alignment: Alignment.center,
                                                      child:
                                                          const CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder:
                                                      (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      alignment: Alignment.center,
                                                      child: const Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      Positioned(
                        top: bannerHeight + 8,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            final bool isActive = _currentBanner == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: isActive ? 18 : 8,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? primaryColor
                                    : Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          }),
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
      ],
    );
  }

  Widget _buildTopBar(Color primaryColor, bool isTablet) {
    final loyaltyState = ref.watch(loyaltyViewModelProvider);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: isTablet ? 60 : 50,
              height: isTablet ? 60 : 50,
              fit: BoxFit.contain,
            ),
            SizedBox(width: isTablet ? 16 : 10),
            Text(
              'CineGhar',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 32 : 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 16 : 12,
            vertical: isTablet ? 8 : 6,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.stars_rounded,
                color: Colors.amber,
                size: isTablet ? 24 : 20,
              ),
              SizedBox(width: isTablet ? 8 : 4),
              if (loyaltyState.status == LoyaltyStatus.loading)
                SizedBox(
                  width: isTablet ? 18 : 14,
                  height: isTablet ? 18 : 14,
                  child: const CircularProgressIndicator(
                    color: Colors.amber,
                    strokeWidth: 2,
                  ),
                )
              else
                Text(
                  '${loyaltyState.loyaltyInfo?.loyaltyPoints ?? 0}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentSalesSection({
    required bool isTablet,
    required double horizontalPadding,
  }) {
    final deals = [
      {
        'title': 'Mid-Week Ticket Deals',
        'subtitle': 'Up to 30% off on Wednesday evening shows for CineGhar members.',
        'footer': 'Applies to shows after 5 PM.',
        'icon': Icons.confirmation_number_outlined,
      },
      {
        'title': 'Snacks Combo Savings',
        'subtitle': 'Redeem points for popcorn & drinks combos at a special member price.',
        'footer': 'Combos from just 120 pts.',
        'icon': Icons.fastfood_outlined,
      },
      {
        'title': 'VIP Premiere Access',
        'subtitle': 'Gold & Platinum members get early booking on red-carpet premieres.',
        'footer': 'Look for the “VIP” tag in show listings.',
        'icon': Icons.stars_outlined,
      },
      {
        'title': 'Birthday Rewards',
        'subtitle': 'Celebrate with bonus points and a complimentary movie ticket during your birthday month.',
        'footer': 'Check your email for your birthday code.',
        'icon': Icons.cake_outlined,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Sales & Offers',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalesPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'See more',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Make every visit count with exclusive discounts and member-only promotions.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ...deals.map((deal) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(deal['icon'] as IconData, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            deal['subtitle'] as String,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            deal['footer'] as String,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }


  Widget _buildNowShowingSection({
    required Color primaryColor,
    required bool isTablet,
    required double horizontalPadding,
  }) {
    final moviesState = ref.watch(moviesViewModelProvider);
    final moviesViewModel = ref.read(moviesViewModelProvider.notifier);

    if (moviesState.status == MoviesStatus.initial) {
      Future.microtask(moviesViewModel.loadInitialMovies);
    }

    final List<MovieEntity> movies = moviesState.movies;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Now Showing',
                style: TextStyle(
                  fontSize: isTablet ? 28 : 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllMoviesPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Show all',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: isTablet ? 16 : 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 28 : 24),
          SizedBox(
            height: isTablet ? 380 : 300,
            child: PageView.builder(
              controller: _movieController,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final double distance =
                    (_currentMoviePage - index).abs().clamp(0.0, 1.0);
                final double scale = 1.0 - (0.16 * distance);

                return AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: scale,
                  child: _MovieCard(
                    movie: movie,
                    isTablet: isTablet,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieCardData {
  final MovieEntity movie;

  const _MovieCardData({required this.movie});
}

class _MovieCard extends StatelessWidget {
  final MovieEntity movie;
  final bool isTablet;

  const _MovieCard({required this.movie, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = isTablet
        ? (size.width * 0.35).clamp(200.0, 350.0)
        : size.width * 0.55;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(
              movieId: movie.id,
              title: movie.title,
              subtitle:
                  '${movie.language ?? ''} | ${movie.genre.join(', ')}',
              imageURL: movie.posterUrl ??
                  'https://via.placeholder.com/300x450?text=CineGhar',
              synopsis: movie.description,
              director: 'CineGhar',
              rating: movie.rating,
              castImages: const [],
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
                  boxShadow: AppColors.cardShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
                  child: Image.network(
                    movie.posterUrl ??
                        'https://via.placeholder.com/300x450?text=CineGhar',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            movie.title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 4 : 3),
          Text(
            '${movie.language ?? ''} • ${movie.duration} min',
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



