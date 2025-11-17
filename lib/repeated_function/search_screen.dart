import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../detail/checker.dart';
import '../helper/project_helper.dart';
import '../model/project_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProjectHelper api = ProjectHelper();
  final TextEditingController _controller = TextEditingController();
  List<PreviewModel> results = [];
  bool loading = false;

  Timer? _debounce; // Added for debounce timing control

  Future<void> _search(String q) async {
    if (!mounted) return;

    // Agar empty search hai toh clear kar do results
    if (q.trim().isEmpty) {
      _debounce?.cancel();
      setState(() {
        results = [];
        loading = false;
      });
      return;
    }

    // Cancel any ongoing debounce timer before starting new one
    _debounce?.cancel();

    // Wait 400ms after last keystroke
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) return;

      setState(() => loading = true);

      try {
        final fetched = await api.searchMoviesAndSeries(q);
        if (mounted) {
          setState(() {
            results = fetched;
            loading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            results = [];
            loading = false;
          });
        }
        debugPrint('Search Error: $e');
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          height: 52,
          margin: const EdgeInsets.fromLTRB(10, 18, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            onChanged: _search,
            // Uses debounce logic now
            textAlignVertical: TextAlignVertical.center,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: 'Search movies or series...',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 15,
              ),
              border: InputBorder.none,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: Icon(Icons.search, color: Colors.amber, size: 22),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.amber.withValues(alpha: 0.7),
                ),
                onPressed: () {
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                  setState(() => results = []);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                      content: Center(
                        child: Text(
                          'Search Cleared',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),

        // Loading Indicator
        if (loading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(color: Colors.amber),
          ),

        // Search Results
        if (!loading && results.isNotEmpty)
          SizedBox(
            height: 430,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final r = results[index];
                final bool isMovie = r.mediaType.toLowerCase() == 'movie';

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DescriptionCheck(r.id, isMovie ? 'movie' : 'tv'),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Poster
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${r.posterPath}',
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 160,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.black26,
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 160,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Info Column
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Type Label
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isMovie ? "MOVIE" : "TV",
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Ratings Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _ratingBox(
                                      Icons.star,
                                      r.vote.toStringAsFixed(1),
                                    ),
                                    const SizedBox(width: 10),
                                    _ratingBox(
                                      Icons.people_outline,
                                      r.popularity.toStringAsFixed(1),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Overview
                                Text(
                                  r.overview.isNotEmpty
                                      ? r.overview
                                      : "No description available",
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // Reusable Rating Box
  Widget _ratingBox(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
