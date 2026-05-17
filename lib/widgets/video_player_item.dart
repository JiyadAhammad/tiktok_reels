import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';

class VideoPlayerItem extends StatelessWidget {
  final Video video;
  final CachedVideoPlayerPlus? player;
  final bool isActive;

  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.player,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Player Background
        Positioned.fill(
          child: _buildVideoPlayer(),
        ),
        
        // Right Side Actions (Likes, Profile, etc.)
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProfilePic(),
              SizedBox(height: 20),
              _buildActionIcon(Icons.favorite, video.likes.toString()),
              SizedBox(height: 20),
              _buildActionIcon(Icons.comment, '120'),
              SizedBox(height: 20),
              _buildActionIcon(Icons.share, 'Share'),
            ],
          ),
        ),
        
        // Bottom Info (Username, Description)
        Positioned(
          left: 16,
          bottom: 20,
          right: 80, // Leave space for right side actions
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                video.username,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                video.description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (player == null || !player!.isInitialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white.withValues(alpha: 0.5)),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (player!.controller.value.isPlaying) {
          player!.controller.pause();
        } else {
          player!.controller.play();
        }
      },
      child: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: player!.controller.value.aspectRatio,
            child: VideoPlayer(player!.controller),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePic() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: video.profilePic.isNotEmpty
            ? Image.network(
                video.profilePic,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
              )
            : Icon(Icons.person),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 36),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
