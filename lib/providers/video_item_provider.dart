import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';

class VideoItemProvider extends ChangeNotifier {
  final String url;
  final int index;
  CachedVideoPlayerPlus? player;
  bool isInitialized = false;
  bool _isActive = false;

  VideoItemProvider({required this.url, required this.index}) {
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    player = CachedVideoPlayerPlus.networkUrl(Uri.parse(url));
    try {
      await player!.initialize();
      player!.controller.setLooping(true);
      if (_isActive) {
        player!.controller.play();
      }
      isInitialized = true;
      notifyListeners();
    } catch (e) {
      // Ignored error in initialization
    }
  }

  void updateActiveState(bool isActive) {
    if (_isActive == isActive) return; // No change
    _isActive = isActive;

    if (player != null && player!.isInitialized) {
      if (_isActive) {
        player!.controller.play();
      } else {
        player!.controller.pause();
        player!.controller.seekTo(Duration.zero);
      }
    }
  }

  void togglePlay() {
    if (player != null && player!.isInitialized) {
      if (player!.controller.value.isPlaying) {
        player!.controller.pause();
      } else {
        player!.controller.play();
      }
    }
  }

  @override
  void dispose() {
    player?.dispose();
    super.dispose();
  }
}
