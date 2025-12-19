import 'package:flutter/material.dart';
import 'movie_detail_screen.dart';

class MovieData {
  final String title;
  final String subtitle;
  final String imageURL;
  final String synopsis;
  final String director;
  final double rating;
  final List<String> castImages;

  const MovieData({
    required this.title,
    required this.subtitle,
    required this.imageURL,
    required this.synopsis,
    required this.director,
    required this.rating,
    required this.castImages,
  });
}

class AllMoviesScreen extends StatelessWidget {
  const AllMoviesScreen({super.key});

  static List<MovieData> getAllMovies() {
    return [
      const MovieData(
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
      const MovieData(
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
      const MovieData(
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
      const MovieData(
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final movies = getAllMovies();
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;
    final crossAxisCount = isTablet ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Showing'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
          childAspectRatio: 0.6,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(
                    title: movie.title,
                    subtitle: movie.subtitle,
                    imageURL: movie.imageURL,
                    synopsis: movie.synopsis,
                    director: movie.director,
                    rating: movie.rating,
                    castImages: movie.castImages,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        movie.imageURL,
                        fit: BoxFit.cover,
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
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



