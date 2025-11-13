import '../api_key/api_key.dart';

// Base URL (for all TMDB API calls)
const String baseUrl = 'https://api.themoviedb.org/3';

// MOVIE ENDPOINTS
String movieUrl(String category) => '$baseUrl/movie/$category?api_key=$apikey';

// TV SERIES ENDPOINTS
String tvUrl(String category) => '$baseUrl/tv/$category?api_key=$apikey';

// TRENDING ENDPOINTS
String trendingUrl(String period /* week | day */) =>
    '$baseUrl/trending/all/$period?api_key=$apikey';

// DETAILS + VIDEOS
String movieDetailUrl(int id) => '$baseUrl/movie/$id?api_key=$apikey';

String tvDetailUrl(int id) => '$baseUrl/tv/$id?api_key=$apikey';

String movieVideosUrl(int id) => '$baseUrl/movie/$id/videos?api_key=$apikey';

String tvVideosUrl(int id) => '$baseUrl/tv/$id/videos?api_key=$apikey';

// REVIEWS
String movieReviewsUrl(int id) => '$baseUrl/movie/$id/reviews?api_key=$apikey';

String tvReviewsUrl(int id) => '$baseUrl/tv/$id/reviews?api_key=$apikey';

// SIMILAR & RECOMMENDED
String movieSimilarUrl(int id) => '$baseUrl/movie/$id/similar?api_key=$apikey';

String movieRecommendUrl(int id) =>
    '$baseUrl/movie/$id/recommendations?api_key=$apikey';

String tvSimilarUrl(int id) => '$baseUrl/tv/$id/similar?api_key=$apikey';

String tvRecommendUrl(int id) =>
    '$baseUrl/tv/$id/recommendations?api_key=$apikey';

// SEARCH
String searchUrl(String query) =>
    '$baseUrl/search/multi?api_key=$apikey&query=${Uri.encodeQueryComponent(query)}';
