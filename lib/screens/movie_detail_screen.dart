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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final size = MediaQuery.of(context).size;
    final posterHeight = size.height * 0.55;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Fixed poster section
          SizedBox(
            height: posterHeight,
            width: double.infinity,
            child: Stack(
              children: [
                // Movie poster
                Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[900],
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.white, size: 50),
                    );
                  },
                ),
                // Gradient overlay at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                ),
                // Back button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
                // Play button at bottom center
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable content section
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Genre and Rating
                    Row(
                      children: [
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: index < rating.round()
                                ? Colors.amber
                                : Colors.grey,
                            size: 20,
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Synopsis
                    Text(
                      synopsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Director
                    Text(
                      'Director : $director',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Cast
                    const Text(
                      'Cast :',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: castImages.map((imageUrl) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white54,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                  ],
                ),
              ),
            ),
          ),
          // Fixed action buttons at bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Favorite button
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Get Tickets button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Get Tickets',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

