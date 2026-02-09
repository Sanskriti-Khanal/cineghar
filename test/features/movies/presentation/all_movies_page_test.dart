import 'dart:async';
import 'dart:io';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';
import 'package:cineghar/features/movies/presentation/pages/all_movies_page.dart';
import 'package:cineghar/features/movies/presentation/providers/movies_providers.dart';
import 'package:cineghar/features/movies/presentation/providers/movies_state.dart';
import 'package:cineghar/features/movies/presentation/viewmodel/movies_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://via.placeholder.com/300x450?text=CineGhar'));
  });

  testWidgets('AllMoviesPage shows movies from state',
      (WidgetTester tester) async {
    const movie = MovieEntity(
      id: '1',
      title: 'Test Movie',
      description: 'Description',
      genre: ['Drama'],
      duration: 120,
      rating: 4.5,
    );

    // Mock network images using HttpOverrides.global
    final originalOverrides = HttpOverrides.current;
    HttpOverrides.global = _MockHttpOverrides();

    try {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            moviesViewModelProvider.overrideWith(
              () => _FakeMoviesViewModel(
                const MoviesState(
                  status: MoviesStatus.loaded,
                  movies: [movie],
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: AllMoviesPage(),
          ),
        ),
      );

      expect(find.text('Test Movie'), findsOneWidget);
    } finally {
      HttpOverrides.global = originalOverrides;
    }
  });
}

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

class _MockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) => _MockHttpClientRequest().closeAndReturn();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) => _MockHttpClientRequest().closeAndReturn();
  @override
  set autoUncompress(bool _autoUncompress) {}
}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  HttpHeaders get headers => _MockHttpHeaders();
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
  Future<HttpClientRequest> closeAndReturn() async => this;
}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _transparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

final List<int> _transparentImage = [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _FakeMoviesViewModel extends MoviesViewModel {
  final MoviesState _state;

  _FakeMoviesViewModel(this._state);

  @override
  MoviesState build() => _state;
}
