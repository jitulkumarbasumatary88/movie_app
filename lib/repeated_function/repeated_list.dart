import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../detail/movie_details.dart';
import '../detail/tv_series_details.dart';
import '../model/project_model.dart';

Widget repeatedList(
  List<PreviewModel> items,
  String title,
  String type,
  int itemLength,
) {
  if (items.isEmpty) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No $title found',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  final length = itemLength < items.length ? itemLength : items.length;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 14, bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.amberAccent,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      SizedBox(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: length,
          itemBuilder: (context, i) {
            final item = items[i];
            final imageUrl = item.posterPath != null
                ? 'https://image.tmdb.org/t/p/w500${item.posterPath}'
                : '';

            return GestureDetector(
              onTap: () {
                if (type == 'movie') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetails(id: item.id),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TvSeriesDetails(id: item.id),
                    ),
                  );
                }
              },
              child: Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black26,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.date.isNotEmpty ? item.date : 'Unknown',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                item.vote.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}
