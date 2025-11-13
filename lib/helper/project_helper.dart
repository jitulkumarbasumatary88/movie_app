import 'dart:async';
import 'package:dio/dio.dart';
import '../all_api/all_api.dart';
import '../model/project_model.dart';

class ProjectHelper {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );

  ProjectHelper() {
    // Interceptor for logging + handling retry on connection reset
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('[GET] ${options.uri}');
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Retry once automatically if connection breaks
          if (e.type == DioExceptionType.connectionError ||
              e.message?.contains('Connection reset by peer') == true) {
            print('Connection reset, retrying after 2 seconds...');
            await Future.delayed(const Duration(seconds: 2));
            try {
              final response = await _dio.request(
                e.requestOptions.path,
                options: Options(method: e.requestOptions.method),
              );
              return handler.resolve(response);
            } catch (err) {
              print('Retry failed: $err');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Safe GET with built-in retry and delay batching
  Future<Response?> _safeGet(
    String url, {
    int retries = 2,
    Duration delay = const Duration(seconds: 2),
  }) async {
    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        final res = await _dio.get(url);
        return res;
      } catch (e) {
        print('Attempt $attempt failed for $url → $e');
        if (attempt < retries) {
          print('Retrying in ${delay.inSeconds} seconds...');
          await Future.delayed(delay);
        } else {
          print('All retries failed for $url');
        }
      }
    }
    return null;
  }

  // TRENDING
  Future<List<TrendingModel>> fetchTrending(String period) async {
    final url = trendingUrl(period);
    print("Fetching Trending: $url");
    final res = await _safeGet(url);
    if (res == null) return [];
    final data = res.data['results'] as List? ?? [];
    return data.map((e) => TrendingModel.fromJson(e)).toList();
  }

  // MOVIES SECTION
  Future<List<MovieModel>> fetchMovies(String category) async {
    final url = movieUrl(category);
    print("Fetching Movies: $url");
    final res = await _safeGet(url);
    if (res == null) return [];
    final data = res.data['results'] as List? ?? [];
    return data.map((e) => MovieModel.fromJson(e)).toList();
  }

  // TV SERIES SECTION
  Future<List<TvModel>> fetchTvShows(String category) async {
    final url = tvUrl(category);
    print("Fetching TV Series: $url");
    final res = await _safeGet(url);
    if (res == null) return [];
    final data = res.data['results'] as List? ?? [];
    return data.map((e) => TvModel.fromJson(e)).toList();
  }

  // UPCOMING MOVIES
  Future<List<UpcomingModel>> fetchUpcomingMovies() async {
    final url = movieUrl('upcoming');
    print("Fetching Upcoming: $url");
    final res = await _safeGet(url);
    if (res == null) return [];
    final data = res.data['results'] as List? ?? [];
    return data.map((e) => UpcomingModel.fromJson(e)).toList();
  }

  // SEARCH (Movies + TV)
  Future<List<PreviewModel>> searchMoviesAndSeries(String query) async {
    if (query.trim().isEmpty) return [];
    final url = searchUrl(query);
    print("Searching: $url");
    final res = await _safeGet(url);
    if (res == null) return [];
    final data = res.data['results'] as List? ?? [];
    return data.map((e) => PreviewModel.fromJson(e)).toList();
  }

  // MOVIE DETAILS
  Future<Map<String, dynamic>> fetchMovieDetailsFull(int id) async {
    print("Fetching Movie Details for ID: $id");
    try {
      final responses = await Future.wait([
        _safeGet(movieDetailUrl(id)),
        _safeGet(movieReviewsUrl(id)),
        _safeGet(movieSimilarUrl(id)),
        _safeGet(movieRecommendUrl(id)),
        _safeGet(movieVideosUrl(id)),
      ]);

      final movieRes = responses[0];
      final reviewRes = responses[1];
      final similarRes = responses[2];
      final recommendRes = responses[3];
      final videoRes = responses[4];

      final reviews = (reviewRes?.data['results'] ?? [])
          .map<ReviewModel>((e) => ReviewModel.fromJson(e))
          .toList();
      final similar = (similarRes?.data['results'] ?? [])
          .map<PreviewModel>((e) => PreviewModel.fromJson(e))
          .toList();
      final recommended = (recommendRes?.data['results'] ?? [])
          .map<PreviewModel>((e) => PreviewModel.fromJson(e))
          .toList();

      final trailerKey =
          (videoRes?.data['results'] as List?)?.firstWhere(
            (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
            orElse: () => {'key': 'aJ0cZTcTh90'},
          )['key'] ??
          'aJ0cZTcTh90';

      return {
        'details': movieRes?.data ?? {},
        'reviews': reviews,
        'similar': similar,
        'recommended': recommended,
        'trailerKey': trailerKey,
      };
    } catch (e) {
      print('Movie Details Fetch Error: $e');
      return {
        'details': {},
        'reviews': [],
        'similar': [],
        'recommended': [],
        'trailerKey': 'aJ0cZTcTh90',
      };
    }
  }

  // TV SERIES DETAILS
  Future<Map<String, dynamic>> fetchTvDetailsFull(int id) async {
    print("Fetching TV Details for ID: $id");
    try {
      final responses = await Future.wait([
        _safeGet(tvDetailUrl(id)),
        _safeGet(tvReviewsUrl(id)),
        _safeGet(tvSimilarUrl(id)),
        _safeGet(tvRecommendUrl(id)),
        _safeGet(tvVideosUrl(id)),
      ]);

      final detailRes = responses[0];
      final reviewRes = responses[1];
      final similarRes = responses[2];
      final recommendRes = responses[3];
      final videoRes = responses[4];

      final reviews = (reviewRes?.data['results'] ?? [])
          .map<ReviewModel>((e) => ReviewModel.fromJson(e))
          .toList();
      final similar = (similarRes?.data['results'] ?? [])
          .map<PreviewModel>((e) => PreviewModel.fromJson(e))
          .toList();
      final recommended = (recommendRes?.data['results'] ?? [])
          .map<PreviewModel>((e) => PreviewModel.fromJson(e))
          .toList();

      final trailerKey =
          (videoRes?.data['results'] as List?)?.firstWhere(
            (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
            orElse: () => {'key': 'aJ0cZTcTh90'},
          )['key'] ??
          'aJ0cZTcTh90';

      return {
        'details': detailRes?.data ?? {},
        'reviews': reviews,
        'similar': similar,
        'recommended': recommended,
        'trailerKey': trailerKey,
      };
    } catch (e) {
      print('TV Details Fetch Error: $e');
      return {
        'details': {},
        'reviews': [],
        'similar': [],
        'recommended': [],
        'trailerKey': 'aJ0cZTcTh90',
      };
    }
  }
}
