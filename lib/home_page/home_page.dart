import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helper/project_helper.dart';
import '../model/project_model.dart';
import '../repeated_function/drawer.dart';
import '../repeated_function/search_bar.dart';
import '../section_page/movie.dart';
import '../section_page/tv_series.dart';
import '../section_page/upcoming.dart';
import '../detail/checker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final ProjectHelper api = ProjectHelper();
  late TabController _tabController;
  String period = 'week';
  List<TrendingModel> trendingWeek = [];
  bool loading = false;
  bool error = false;

  Future<void> loadTrending(String p, {bool retry = false}) async {
    if (!retry) setState(() => loading = true);
    try {
      final res = await api.fetchTrending(p);
      if (res.isEmpty && !retry) {
        await Future.delayed(const Duration(seconds: 2));
        await loadTrending(p, retry: true);
      } else {
        trendingWeek = res;
        error = res.isEmpty;
      }
    } catch (_) {
      error = true;
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    unawaited(loadTrending(period));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerFunction(),
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Trending 🔥',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButton(
                      underline: Container(height: 0),
                      dropdownColor: Colors.black.withValues(alpha: 0.7),
                      icon: const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.amber,
                        size: 30,
                      ),
                      value: period,
                      items: const [
                        DropdownMenuItem(
                          value: 'week',
                          child: Text(
                            'Weekly',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'day',
                          child: Text(
                            'Daily',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          trendingWeek.clear();
                          period = value!;
                        });
                        loadTrending(period);
                      },
                    ),
                  ),
                ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Builder(
                builder: (context) {
                  if (loading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  } else if (error || trendingWeek.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            color: Colors.grey,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No trending data',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            onPressed: () => loadTrending(period),
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      height: MediaQuery.of(context).size.height,
                    ),
                    items: trendingWeek.map((i) {
                      final index = trendingWeek.indexOf(i);
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DescriptionCheck(i.id, i.mediaType),
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Poster Background
                            CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w500${i.posterPath}',
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: Colors.black26,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                            ),

                            // Overlay shade
                            Container(
                              color: Colors.black.withValues(alpha: 0.35),
                            ),

                            // Number (Left)
                            Positioned(
                              left: 12,
                              right: 12,
                              bottom: 14,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Number Box (Left)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.amberAccent.withValues(
                                          alpha: 0.6,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '#${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  // Rating Box (Right)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.amberAccent.withValues(
                                          alpha: 0.6,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amberAccent,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          i.voteAverage.toStringAsFixed(1),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),

          // Tabs Section
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: const Color(0xFF0E0E0E),
                child: Column(
                  children: [
                    const SearchBarFunction(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelColor: Colors.white,
                        tabs: const [
                          Tab(child: Center(child: Text('TV Series'))),
                          Tab(child: Center(child: Text('Movies'))),
                          Tab(child: Center(child: Text('Upcoming'))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1100,
                      child: TabBarView(
                        controller: _tabController,
                        children: const [TvSeries(), Movie(), Upcoming()],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
