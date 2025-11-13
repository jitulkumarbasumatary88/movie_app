import 'package:flutter/material.dart';
import 'movie_details.dart';
import 'tv_series_details.dart';

class DescriptionCheck extends StatefulWidget {
  final int newId;
  final String newType; // 'movie' / 'tv' / 'person'
  const DescriptionCheck(this.newId, this.newType, {super.key});

  @override
  State<DescriptionCheck> createState() => _DescriptionCheckState();
}

class _DescriptionCheckState extends State<DescriptionCheck> {
  @override
  Widget build(BuildContext context) {
    if (widget.newType == 'movie') return MovieDetails(id: widget.newId);
    if (widget.newType == 'tv') return TvSeriesDetails(id: widget.newId);
    return _errorUi(context, 'Person/Other page under development');
  }
}

Widget _errorUi(BuildContext context, String msg) => Scaffold(
  backgroundColor: const Color(0xFF0E0E0E),
  appBar: AppBar(backgroundColor: Colors.black, title: const Text('Error')),
  body: Center(
    child: Text(msg, style: const TextStyle(color: Colors.white70)),
  ),
);
