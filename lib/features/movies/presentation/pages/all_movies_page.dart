import 'package:cineghar/core/utils/proximity_gesture_detector.dart';
import 'package:cineghar/features/movies/presentation/providers/movies_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';
import 'package:cineghar/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:cineghar/features/movies/presentation/providers/movies_state.dart';

class AllMoviesPage extends ConsumerStatefulWidget {
  const AllMoviesPage({super.key});

  @override
  ConsumerState<AllMoviesPage> createState() => _AllMoviesPageState();
}

class _AllMoviesPageState extends ConsumerState<AllMoviesPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  late final ProximityGestureDetector _gestureDetector;

  @override
  void initState() {
    super.initState();
    _gestureDetector = ProximityGestureDetector();
    _gestureDetector.gestures.listen(_handleGesture);
    _gestureDetector.start();

    // Trigger initial load if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(moviesViewModelProvider);
      if (state.status == MoviesStatus.initial) {
        ref.read(moviesViewModelProvider.notifier).loadInitialMovies();
      }
    });
  }

  @override
  void dispose() {
    _gestureDetector.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleGesture(ProximityGesture gesture) {
    if (!mounted) return;

    switch (gesture) {
      case ProximityGesture.swipeNext:
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
        _showFeedback("Next Movie (Wave)");
        break;
      case ProximityGesture.swipePrevious:
        _pageController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
        _showFeedback("Previous Movie (2 Waves)");
        break;
      case ProximityGesture.holdDismiss:
        Navigator.of(context).pop();
        _showFeedback("Going Back (Hold)");
        break;
      default:
        break;
    }
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary.withOpacity(0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(moviesViewModelProvider);
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background UI
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, isTablet),
                Expanded(
                  child: _buildContent(state, isTablet),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Showing',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Wave hand near sensor to browse',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(MoviesState state, bool isTablet) {
    if (state.status == MoviesStatus.loading && state.movies.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (state.status == MoviesStatus.error && state.movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Failed to load movies',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(moviesViewModelProvider.notifier).loadInitialMovies(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.movies.isEmpty) {
      return const Center(
        child: Text('No movies available.', style: TextStyle(color: Colors.white)),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: state.movies.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final movie = state.movies[index];
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 1.0;
            if (_pageController.position.haveDimensions) {
              value = _pageController.page! - index;
              value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
            }
            return Center(
              child: Transform.scale(
                scale: Curves.easeIn.transform(value),
                child: child,
              ),
            );
          },
          child: _CarouselCard(movie: movie),
        );
      },
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final MovieEntity movie;

  const _CarouselCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(
              movieId: movie.id,
              title: movie.title,
              subtitle: '${movie.language ?? ''} | ${movie.genre.join(', ')}',
              imageURL: movie.posterUrl ?? 'https://via.placeholder.com/300x450?text=CineGhar',
              synopsis: movie.description,
              director: 'CineGhar',
              rating: movie.rating,
              castImages: const [],
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.75,
        height: size.height * 0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster
              Image.network(
                movie.posterUrl ?? 'https://via.placeholder.com/300x450?text=CineGhar',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.95),
                      ],
                    ),
                  ),
                ),
              ),
              // Info
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.duration} min',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.rating}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


