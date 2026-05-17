import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';
import '../services/video_service.dart';
import '../widgets/video_player_item.dart';

class ReelsScreen extends StatefulWidget {
  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final VideoService _videoService = VideoService();
  List<Video> _videos = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  
  // Cache of players
  final Map<int, CachedVideoPlayerPlus> _players = {};

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final videos = await _videoService.fetchVideos();
    setState(() {
      _videos = videos;
      _isLoading = false;
    });
    
    if (_videos.isNotEmpty) {
      _preloadVideos(0); // preload the first few videos
    }
  }

  void _preloadVideos(int currentIndex) {
    // We want to preload the current video and the next 3 videos
    final int preloadCount = 3;
    
    for (int i = 0; i <= preloadCount; i++) {
      final indexToLoad = currentIndex + i;
      if (indexToLoad < _videos.length) {
        _initializePlayer(indexToLoad);
      }
    }
    
    // Dispose players that are far behind or far ahead to save memory
    final List<int> keysToRemove = [];
    _players.forEach((index, player) {
      if (index < currentIndex - 1 || index > currentIndex + preloadCount) {
        player.dispose();
        keysToRemove.add(index);
      }
    });
    
    for (var key in keysToRemove) {
      _players.remove(key);
    }
  }

  Future<void> _initializePlayer(int index) async {
    if (_players.containsKey(index)) return; // Already initialized or initializing
    
    final player = CachedVideoPlayerPlus.networkUrl(Uri.parse(_videos[index].url));
    _players[index] = player;
    
    try {
      await player.initialize();
      player.controller.setLooping(true);
      // Play immediately if it's the current active index
      if (index == _currentIndex) {
        player.controller.play();
      }
      if (mounted) setState(() {});
    } catch (e) {
      // Ignored error in initialization
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Pause all and play the current one
    _players.forEach((idx, player) {
      if (idx == index) {
        player.controller.play();
      } else {
        player.controller.pause();
        // Reset to beginning if desired
        player.controller.seekTo(Duration.zero);
      }
    });
    
    // Preload next batch
    _preloadVideos(index);
  }

  @override
  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    _players.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_videos.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('No videos available', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final video = _videos[index];
          final player = _players[index];
          
          return VideoPlayerItem(
            video: video,
            player: player,
            isActive: index == _currentIndex,
          );
        },
      ),
    );
  }
}
