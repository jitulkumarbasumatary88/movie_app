import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../detail/checker.dart';
import '../helper/project_helper.dart';
import '../model/project_model.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  final ProjectHelper api = ProjectHelper();
  List<UpcomingModel> upcoming = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    upcoming = await api.fetchUpcomingMovies();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    if (upcoming.isEmpty) {
      return const Center(
        child: Text(
          'No upcoming movies',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Text(
              'Upcoming Movies',
              style: TextStyle(
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
              itemCount: upcoming.length,
              itemBuilder: (_, i) {
                final m = upcoming[i];
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
                      // Poster
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
                      // Movie title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          m.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      // Rating
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
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
      ),
    );
  }
}
