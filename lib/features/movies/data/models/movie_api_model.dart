import 'package:cineghar/core/api/api_endpoints.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';

class MovieApiModel {
  final String id;
  final String title;
  final String description;
  final List<String> genre;
  final int duration;
  final double rating;
  final String? posterUrl;
  final String? releaseDate;
  final String? language;

  MovieApiModel({
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

  factory MovieApiModel.fromJson(Map<String, dynamic> json) {
    final rawGenre = json['genre'];
    return MovieApiModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      genre: rawGenre is List
          ? rawGenre.map((e) => e.toString()).toList()
          : const [],
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      posterUrl: json['posterUrl']?.toString(),
      releaseDate: json['releaseDate']?.toString(),
      language: json['language']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'genre': genre,
      'duration': duration,
      'rating': rating,
      'posterUrl': posterUrl,
      'releaseDate': releaseDate,
      'language': language,
    };
  }

  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      title: title,
      description: description,
      genre: genre,
      duration: duration,
      rating: rating,
      posterUrl: _buildPosterUrl(posterUrl),
      releaseDate: releaseDate,
      language: language,
    );
  }

  static String? _buildPosterUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http')) return raw;
    return '${ApiEndpoints.hostBaseUrl}$raw';
  }
}
