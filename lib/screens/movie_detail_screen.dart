import 'package:cineghar/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageURL;
  final String synopsis;
  final String director;
  final double rating;
  final List<String> castImages;

  const MovieDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageURL,
    required this.synopsis,
    required this.director,
    required this.rating,
    required this.castImages,
  });

  @override
  Widget build(BuildContext context) {
    return MovieDetailPage(
      title: title,
      subtitle: subtitle,
      imageURL: imageURL,
      synopsis: synopsis,
      director: director,
      rating: rating,
      castImages: castImages,
    );
  }
}
