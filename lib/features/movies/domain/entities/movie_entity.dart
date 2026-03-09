import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> genre;
  final int duration;
  final double rating;
  final String? posterUrl;
  final String? releaseDate;
  final String? language;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.duration,
    required this.rating,
    this.posterUrl,
    this.releaseDate,
    this.language,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        genre,
        duration,
        rating,
        posterUrl,
        releaseDate,
        language,
      ];
}
