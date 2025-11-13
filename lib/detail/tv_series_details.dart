import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../helper/project_helper.dart';
import '../home_page/home_page.dart';
import '../model/project_model.dart';
import '../repeated_function/review.dart';
import '../repeated_function/slider.dart';
import '../repeated_function/trailer_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TvSeriesDetails extends StatefulWidget {
  final int id;

  const TvSeriesDetails({super.key, required this.id});

  @override
  State<TvSeriesDetails> createState() => _TvSeriesDetailsState();
}

class _TvSeriesDetailsState extends State<TvSeriesDetails> {
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
      data = await api.fetchTvDetailsFull(widget.id);
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
                'Error loading TV details',
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
    final creators = (detail['created_by'] as List? ?? [])
        .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
        .toList();

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
                child: TrailerWatch(trailerYtID: trailerKey),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 12),

              // Series Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  detail['name'] ??
                      detail['original_name'] ??
                      'Untitled Series',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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

              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Series Overview:',
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

              if (reviews.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: ReviewUI(revDetails: reviews),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: ${detail['status'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'First Air Date: ${detail['first_air_date'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Total Seasons: ${(detail['seasons'] as List?)?.length ?? 0}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              if (creators.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 14),
                  child: Text(
                    'Created By:',
                    style: TextStyle(color: Colors.amberAccent, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: creators.length,
                    itemBuilder: (_, i) {
                      final c = creators[i];
                      final p = c['profile_path'];
                      return Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF191919),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: p != null
                                    ? 'https://image.tmdb.org/t/p/w500$p'
                                    : '',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => const CircleAvatar(
                                  radius: 45,
                                  child: Icon(Icons.person),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 110,
                              child: Text(
                                '${c['name']}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],

              sliderList(similar, 'Similar Series', 'tv', similar.length),
              sliderList(
                recommended,
                'Recommended Series',
                'tv',
                recommended.length,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
