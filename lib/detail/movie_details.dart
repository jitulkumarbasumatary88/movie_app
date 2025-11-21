import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../helper/project_helper.dart';
import '../home_page/home_page.dart';
import '../model/project_model.dart';
import '../repeated_function/favourite_button.dart';
import '../repeated_function/review_screen.dart';
import '../repeated_function/repeated_list.dart';
import '../repeated_function/trailer_screen.dart';

class MovieDetails extends StatefulWidget {
  final int id;

  const MovieDetails({super.key, required this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  final ProjectHelper api = ProjectHelper();
  Map<String, dynamic> data = {};
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      data = await api.fetchMovieDetailsFull(widget.id);
      if (data.isEmpty) error = true;
    } catch (e) {
      error = true;
    }
    loading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0E0E0E),
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    if (error || data.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0E0E0E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Error loading movie details',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                    error = false;
                  });
                  _load();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final detail = Map<String, dynamic>.from(data['details'] ?? {});
    final reviews =
        (data['reviews'] as List?)?.cast<ReviewModel>() ?? <ReviewModel>[];
    final similar =
        (data['similar'] as List?)?.cast<PreviewModel>() ?? <PreviewModel>[];
    final recommended =
        (data['recommended'] as List?)?.cast<PreviewModel>() ??
        <PreviewModel>[];
    final trailerKey = (data['trailerKey'] ?? 'aJ0cZTcTh90') as String;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
            leading: IconButton(
              icon: const Icon(
                FontAwesomeIcons.circleArrowLeft,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.houseUser,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                  (r) => false,
                ),
              ),
            ],
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: TrailerScreen(trailerYtID: trailerKey),
              ),
            ),
          ),

          // Content Section
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 12),

              // Movie Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  detail['title'] ?? detail['name'] ?? 'Untitled Movie',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Favourite
              AddFavoriteButton(
                tmdbid: widget.id.toString(),
                tmdbtype: "movie",
                title: (detail['title'] ?? detail['name'] ?? 'Untitled')
                    .toString(),
                rating: detail['vote_average']?.toString() ?? "0.0",
                poster: detail['poster_path'],
                iconSize: 32,
              ),

              const SizedBox(height: 10),

              // Genres
              if ((detail['genres'] as List?)?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: (detail['genres'] as List).map((g) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${g['name']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              // Overview
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Movie Overview:',
                  style: TextStyle(color: Colors.amberAccent, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  (detail['overview']?.toString().isNotEmpty ?? false)
                      ? detail['overview']
                      : 'No overview available',
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ),

              // Reviews
              if (reviews.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: ReviewScreen(revDetails: reviews),
                ),

              // Info
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Release Date: ${detail['release_date'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Budget: \$${detail['budget'] ?? 0}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Revenue: \$${detail['revenue'] ?? 0}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              repeatedList(similar, 'Similar Movies', 'movie', similar.length),
              repeatedList(
                recommended,
                'Recommended Movies',
                'movie',
                recommended.length,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
