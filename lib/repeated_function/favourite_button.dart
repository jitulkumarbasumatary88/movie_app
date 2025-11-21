import 'package:flutter/material.dart';

import '../sqflite/sqflite.dart';

class AddFavoriteButton extends StatefulWidget {
  final String tmdbid;
  final String tmdbtype;
  final String title;
  final String rating;
  final double iconSize;
  final String poster;

  const AddFavoriteButton({
    super.key,
    required this.tmdbid,
    required this.tmdbtype,
    required this.title,
    required this.rating,
    required this.poster,
    this.iconSize = 28.0,
  });

  @override
  _AddFavoriteButtonState createState() => _AddFavoriteButtonState();
}

class _AddFavoriteButtonState extends State<AddFavoriteButton> {
  bool isFav = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _checkFav();
  }

  _checkFav() async {
    final val = await FavMovielist().search(
      widget.tmdbid,
      widget.title,
      widget.tmdbtype,
    );

    setState(() {
      isFav = val != 0;
      loading = false;
    });
  }

  _toggleFav() async {
    if (isFav) {
      await FavMovielist().deletespecific(widget.tmdbid, widget.tmdbtype);
      setState(() => isFav = false);
    } else {
      await FavMovielist().insert({
        'tmdbid': widget.tmdbid,
        'tmdbtype': widget.tmdbtype,
        'tmdbname': widget.title,
        'tmdbrating': widget.rating,
        'tmdbposter': widget.poster,
      });
      setState(() => isFav = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(width: widget.iconSize, height: widget.iconSize);
    }

    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : Colors.white,
        size: widget.iconSize,
      ),
      onPressed: _toggleFav,
    );
  }
}
