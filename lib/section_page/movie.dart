import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../detail/checker.dart';
import '../helper/project_helper.dart';
import '../model/project_model.dart';

class Movie extends StatefulWidget {
  const Movie({super.key});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  final ProjectHelper api = ProjectHelper();

  List<MovieModel> popular = [];
  List<MovieModel> nowPlaying = [];
  List<MovieModel> topRated = [];

  bool pLoaded = false, nLoaded = false, tLoaded = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadSequential());
  }

  Future<void> _loadSequential() async {
    popular = await api.fetchMovies('popular');
    setState(() => pLoaded = true);

    await Future.delayed(const Duration(milliseconds: 400));
    nowPlaying = await api.fetchMovies('now_playing');
    setState(() => nLoaded = true);

    await Future.delayed(const Duration(milliseconds: 400));
    topRated = await api.fetchMovies('top_rated');
    setState(() => tLoaded = true);
  }

  Widget _row(String title, List<MovieModel> list) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final m = list[i];
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DescriptionCheck(m.id, 'movie'),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${m.posterPath}',
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        m.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            m.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!pLoaded)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            )
          else
            _row('Popular Now', popular),
          if (pLoaded && !nLoaded)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            )
          else if (nLoaded)
            _row('Now Playing', nowPlaying),
          if (nLoaded && !tLoaded)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            )
          else if (tLoaded)
            _row('Top Rated', topRated),
        ],
      ),
    );
  }
}
