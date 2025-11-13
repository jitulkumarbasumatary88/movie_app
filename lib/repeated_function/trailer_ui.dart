import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerWatch extends StatefulWidget {
  final String trailerYtID;

  const TrailerWatch({super.key, required this.trailerYtID});

  @override
  State<TrailerWatch> createState() => _TrailerWatchState();
}

class _TrailerWatchState extends State<TrailerWatch> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerYtID,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
        forceHD: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () => debugPrint('YouTube player ready'),
      ),
    );
  }
}
