// Base Interface
abstract class BaseModel {
  Map<String, dynamic> toJson();
}

// MOVIE MODEL
class MovieModel implements BaseModel {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'] ?? 0,
    title: json['title'] ?? 'Unknown',
    posterPath: json['poster_path'] ?? '',
    voteAverage: (json['vote_average'] ?? 0).toDouble(),
    releaseDate: json['release_date'] ?? 'N/A',
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster_path': posterPath,
    'vote_average': voteAverage,
    'release_date': releaseDate,
  };
}

// TV MODEL
class TvModel implements BaseModel {
  final int id;
  final String name;
  final String posterPath;
  final double voteAverage;
  final String firstAirDate;

  TvModel({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.voteAverage,
    required this.firstAirDate,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
    id: json['id'] ?? 0,
    name: json['original_name'] ?? json['name'] ?? 'Unknown',
    posterPath: json['poster_path'] ?? '',
    voteAverage: (json['vote_average'] ?? 0).toDouble(),
    firstAirDate: json['first_air_date'] ?? 'N/A',
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'original_name': name,
    'poster_path': posterPath,
    'vote_average': voteAverage,
    'first_air_date': firstAirDate,
  };
}

// REVIEW MODEL
class ReviewModel implements BaseModel {
  final String author;
  final String content;
  final String rating;
  final String avatar;
  final String date;

  ReviewModel({
    required this.author,
    required this.content,
    required this.rating,
    required this.avatar,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final details = json['author_details'] ?? {};
    return ReviewModel(
      author: json['author'] ?? 'Unknown',
      content: json['content'] ?? 'No review available',
      rating: details['rating']?.toString() ?? 'N/A',
      avatar: details['avatar_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${details['avatar_path']}'
          : 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
      date: (json['created_at'] ?? '').toString().substring(0, 10),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'author': author,
    'content': content,
    'rating': rating,
    'avatar': avatar,
    'date': date,
  };
}

// TRENDING MODEL
class TrendingModel implements BaseModel {
  final int id;
  final String posterPath;
  final double voteAverage;
  final String mediaType;

  TrendingModel({
    required this.id,
    required this.posterPath,
    required this.voteAverage,
    required this.mediaType,
  });

  factory TrendingModel.fromJson(Map<String, dynamic> json) => TrendingModel(
    id: json['id'] ?? 0,
    posterPath: json['poster_path'] ?? '',
    voteAverage: (json['vote_average'] ?? 0).toDouble(),
    mediaType: json['media_type'] ?? (json['title'] != null ? 'movie' : 'tv'),
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'poster_path': posterPath,
    'vote_average': voteAverage,
    'media_type': mediaType,
  };
}

// UPCOMING MODEL
class UpcomingModel implements BaseModel {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;

  UpcomingModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory UpcomingModel.fromJson(Map<String, dynamic> json) => UpcomingModel(
    id: json['id'] ?? 0,
    title: json['title'] ?? 'Unknown',
    posterPath: json['poster_path'] ?? '',
    voteAverage: (json['vote_average'] ?? 0).toDouble(),
    releaseDate: json['release_date'] ?? 'N/A',
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster_path': posterPath,
    'vote_average': voteAverage,
    'release_date': releaseDate,
  };
}

// UNIVERSAL PREVIEW MODEL (used in Search/Similar/Recommendations)
class PreviewModel implements BaseModel {
  final int id;
  final String title;
  final String posterPath;
  final double vote;
  final String date;
  final double popularity;
  final String overview;
  final String mediaType;

  PreviewModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.vote,
    required this.date,
    required this.popularity,
    required this.overview,
    required this.mediaType,
  });

  factory PreviewModel.fromJson(Map<String, dynamic> json) {
    // Smart detection for TV / Movie
    String detectedType =
        json['media_type'] ??
        (json['title'] != null
            ? 'movie'
            : (json['original_name'] != null || json['name'] != null)
            ? 'tv'
            : 'unknown');

    return PreviewModel(
      id: json['id'] ?? 0,
      title:
          json['title'] ?? json['original_name'] ?? json['name'] ?? 'Unknown',
      posterPath: json['poster_path'] ?? '',
      vote: (json['vote_average'] ?? 0).toDouble(),
      date: json['release_date'] ?? json['first_air_date'] ?? 'N/A',
      popularity: (json['popularity'] ?? 0).toDouble(),
      overview: json['overview'] ?? 'No description available',
      mediaType: detectedType,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster_path': posterPath,
    'vote': vote,
    'date': date,
    'popularity': popularity,
    'overview': overview,
    'media_type': mediaType,
  };
}
