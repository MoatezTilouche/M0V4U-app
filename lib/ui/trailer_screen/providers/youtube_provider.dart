import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeProvider with ChangeNotifier {
  late YoutubePlayerController _controller;

  YoutubePlayerController get controller => _controller;

  void initController(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    )..addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.hasPlayed && _controller.value.isReady) {
      if (_controller.value.playerState == PlayerState.ended) {
        onVideoEnded?.call(); // You can assign this externally
      }
    }
  }

// Callback function setter
  void Function()? onVideoEnded;

  void disposeController() {
    _controller.removeListener(_videoListener);
    _controller.pause();
    _controller.dispose();
  }
}
