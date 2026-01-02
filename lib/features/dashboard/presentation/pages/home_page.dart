import 'package:flutter/material.dart';
import 'package:cineghar/features/dashboard/presentation/pages/sales_page.dart';
import 'package:cineghar/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:cineghar/features/movies/presentation/pages/all_movies_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
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
    final bool isTablet = size.shortestSide > 600;
    final double horizontalPadding = isTablet ? 40.0 : 16.0;
    final double bannerHeight = isTablet ? 260 : 170;
    final double maxContentWidth = isTablet ? 1200 : double.infinity;

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
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
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
                                SizedBox(height: isTablet ? 24 : 20),
                                _buildSalesSection(
                                  primaryColor: primaryColor,
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
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
                                  child: Builder(
                                    builder: (_) {
                                      if (index == 0) {
                                        return Image.asset(
                                          'assets/images/home_banner1.png',
                                          fit: BoxFit.fill,
                                        );
                                      } else if (index == 1) {
                                        return Image.network(
                                          'https://t4.ftcdn.net/jpg/02/81/07/63/360_F_281076350_HzOotmfZngtpedG18Pz5dPXbidk95pkD.jpg',
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: const CircularProgressIndicator(strokeWidth: 2),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: const Icon(Icons.broken_image, color: Colors.grey),
                                            );
                                          },
                                        );
                                      } else {
                                        return Image.network(
                                          'https://static.vecteezy.com/system/resources/thumbnails/001/950/057/small/now-showing-with-electric-bulbs-frame-on-red-curtain-background-free-vector.jpg',
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: const CircularProgressIndicator(strokeWidth: 2),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: const Icon(Icons.broken_image, color: Colors.grey),
                                            );
                                          },
                                        );
                                      }
                                    },
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
                                borderRadius: BorderRadius.circular(4),
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
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_paused,
            color: Colors.white,
            size: isTablet ? 32 : 24,
          ),
          iconSize: isTablet ? 32 : 24,
        ),
      ],
    );
  }

  Widget _buildSalesSection({
    required Color primaryColor,
    required bool isTablet,
    required double horizontalPadding,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales',
                style: TextStyle(
                  fontSize: isTablet ? 28 : 22,
                  fontWeight: FontWeight.w700,
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
          SizedBox(height: isTablet ? 16 : 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
            child: Image.asset(
              'assets/images/wednesday_sale.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: isTablet ? 220 : 140,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNowShowingSection({
    required Color primaryColor,
    required bool isTablet,
    required double horizontalPadding,
  }) {
    final movies = <_MovieCardData>[
      _MovieCardData(
        title: 'Bhagwat',
        subtitle: 'Hindi | Thriller',
        imageURL: "https://akamaividz2.zee5.com/image/upload/w_336,h_504,c_scale,f_webp,q_auto:eco/resources/0-0-1z5831123/portrait/1920x7701d4dfe8f34f84d5d8218f4d8ee316b510d0c411f236843508e9724976004dde5.jpg",
        synopsis: 'Bhagwat is a thrilling Hindi film that explores intense drama and suspense.',
        director: 'Unknown Director',
        rating: 4.0,
        castImages: [
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
        ],
      ),
      _MovieCardData(
        title: 'Oppenheimer',
        subtitle: 'English | Sci-Fi',
        imageURL: "https://m.media-amazon.com/images/M/MV5BM2RmYmVmMzctMzc5Ny00MmNiLTgxMGUtYjk1ZDRhYjA2YTU0XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
        synopsis: 'Oppenheimer is a 2023 biographical thriller film directed by Christopher Nolan about J. Robert Oppenheimer, the theoretical physicist who led the Manhattan Project to develop the first atomic bombs. Starring Cillian Murphy as Oppenheimer, the movie dramatizes his life, work, and his 1954 security hearing, exploring the moral and political conflicts surrounding his role in creating the atomic bomb.',
        director: 'Christopher Nolan',
        rating: 5.0,
        castImages: [
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
        ],
      ),
      _MovieCardData(
        title: 'John Wick 4',
        subtitle: 'English | Action',
        imageURL: 'https://m.media-amazon.com/images/M/MV5BMDExZGMyOTMtMDgyYi00NGIwLWJhMTEtOTdkZGFjNmZiMTEwXkEyXkFqcGdeQXVyMjM4NTM5NDY@._V1_FMjpg_UX1000_.jpg',
        synopsis: 'John Wick 4 continues the action-packed saga of the legendary assassin as he faces new challenges and enemies.',
        director: 'Chad Stahelski',
        rating: 4.5,
        castImages: [
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
        ],
      ),
      _MovieCardData(
        title: 'Pathaan',
        subtitle: 'Hindi | Action',
        imageURL: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi7Jj1HSHylgbNkDcX-rdKp9G7UOXGUUSt2w&s',
        synopsis: 'Pathaan is a high-octane action thriller featuring Shah Rukh Khan in an exciting spy adventure.',
        director: 'Siddharth Anand',
        rating: 4.2,
        castImages: [
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
        ],
      ),
    ];

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
                final double scale = 1.0 - (0.2 * distance);

                return Transform.scale(
                  scale: scale,
                  child: _MovieCard(
                    data: movie,
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
  final String title;
  final String subtitle;
  final String imageURL;
  final String synopsis;
  final String director;
  final double rating;
  final List<String> castImages;

  const _MovieCardData({
    required this.title,
    required this.subtitle,
    required this.imageURL,
    required this.synopsis,
    required this.director,
    required this.rating,
    required this.castImages,
  });
}

class _MovieCard extends StatelessWidget {
  final _MovieCardData data;
  final bool isTablet;

  const _MovieCard({required this.data, required this.isTablet});

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
              title: data.title,
              subtitle: data.subtitle,
              imageURL: data.imageURL,
              synopsis: data.synopsis,
              director: data.director,
              rating: data.rating,
              castImages: data.castImages,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: isTablet ? 15 : 10,
                      offset: Offset(0, isTablet ? 8 : 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
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
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            data.title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 16,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 4 : 3),
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



