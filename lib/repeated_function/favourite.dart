import 'package:flutter/material.dart';
import '../model/favourite_model.dart';
import '../sqflite/sqflite.dart';
import '../detail/movie_details.dart';
import '../detail/tv_series_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  List<FavoriteModel> favs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFavs();
  }

  loadFavs() async {
    final rows = await FavMovielist().queryAllSortedDate();
    favs = rows.map((e) => FavoriteModel.fromMap(e)).toList();
    setState(() => loading = false);
  }

  openDetails(FavoriteModel item) {
    if (item.tmdbtype == "movie") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetails(id: int.parse(item.tmdbid)),
        ),
      ).then((_) => loadFavs());
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TvSeriesDetails(id: int.parse(item.tmdbid)),
        ),
      ).then((_) => loadFavs());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Favourite List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : favs.isEmpty
          ? const Center(
        child: Text(
          "No Favourites Added",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        itemCount: favs.length,
        itemBuilder: (context, index) {
          final item = favs[index];

          return GestureDetector(
            onTap: () => openDetails(item),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // ⭐ Cached Image Here
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      height: 90,
                      width: 70,
                      fit: BoxFit.cover,
                      imageUrl:
                      "https://image.tmdb.org/t/p/w500${item.tmdbposter}",
                      placeholder: (context, url) => Container(
                        height: 90,
                        width: 70,
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white70),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 90,
                        width: 70,
                        color: Colors.black26,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tmdbname,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Rating: ${item.tmdbrating}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Type: ${item.tmdbtype}",
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FavMovielist().deletespecific(
                        item.tmdbid,
                        item.tmdbtype,
                      );
                      loadFavs();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
