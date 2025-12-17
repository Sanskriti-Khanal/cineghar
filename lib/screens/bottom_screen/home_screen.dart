import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  // Narrower pages so side cards are clearly visible
  final PageController _movieController = PageController(viewportFraction: 0.6);
  double _currentMoviePage = 0;

  @override
  void initState() {
    super.initState();
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
    final isTablet = size.width > 600;
    final double bannerHeight = isTablet ? 220 : 170;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
        ),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.2))),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: _buildTopBar(primaryColor),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Transform.translate(
                        offset: const Offset(0, -40),
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
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Builder(
                                    builder: (_) {
                                      if (index == 0) {
                                        
                                        return Image.asset(
                                          'assets/images/home_banner1.png',
                                          fit: BoxFit.cover,
                                        );
                                      }
                          
                                      return Container(
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Banner ${index + 1}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
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
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _buildNowShowingSection(
                          primaryColor: primaryColor,
                          isTablet: isTablet,
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
    );
  }

  Widget _buildTopBar(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              'CineGhar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_paused, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildNowShowingSection({
    required Color primaryColor,
    required bool isTablet,
  }) {
    final movies = <_MovieCardData>[
      const _MovieCardData(
        title: 'Bhagwat',
        subtitle: 'Hindi | Thriller',
        imageURL:"https://akamaividz2.zee5.com/image/upload/w_336,h_504,c_scale,f_webp,q_auto:eco/resources/0-0-1z5831123/portrait/1920x7701d4dfe8f34f84d5d8218f4d8ee316b510d0c411f236843508e9724976004dde5.jpg"
      ),
      const _MovieCardData(
        title: 'Oppenheimer',
        subtitle: 'English | Sci-Fi',
        imageURL:"https://m.media-amazon.com/images/M/MV5BM2RmYmVmMzctMzc5Ny00MmNiLTgxMGUtYjk1ZDRhYjA2YTU0XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
      ),
      const _MovieCardData(
        title: 'John Wick 4',
        subtitle: 'English | Action',
        imageURL: 'https://m.media-amazon.com/images/M/MV5BMDExZGMyOTMtMDgyYi00NGIwLWJhMTEtOTdkZGFjNmZiMTEwXkEyXkFqcGdeQXVyMjM4NTM5NDY@._V1_FMjpg_UX1000_.jpg',
      ),
      const _MovieCardData(
        title: 'Pathaan',
        subtitle: 'Hindi | Action',
        imageURL: 'https://upload.wikimedia.org/wikipedia/en/c/c3/Pathaan_film_poster.jpg',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Now Showing',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Show all',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: isTablet ? 360 : 300,
            child: PageView.builder(
              controller: _movieController,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
              
                final double distance =
                    (_currentMoviePage - index).abs().clamp(0.0, 1.0);

               
                final double scale = 1.0 - (0.2 * distance);

                return Transform.scale(
                  scale: scale,
                  child: _MovieCard(
                    data: movie,
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
  final String title;
  final String subtitle;
  final String imageURL;

  const _MovieCardData({
    required this.title,
    required this.subtitle,
    required this.imageURL,
  });
}

class _MovieCard extends StatelessWidget {
  final _MovieCardData data;

  const _MovieCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.55,
              // fixed width so side cards peek in clearly
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  data.imageURL,
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
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          data.subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
