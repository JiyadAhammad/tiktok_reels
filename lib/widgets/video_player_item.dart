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
          child: _VideoPlayer(player: player),
        ),
        
        // Right Side Actions (Likes, Profile, etc.)
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ProfilePic(profilePic: video.profilePic),
              const SizedBox(height: 20),
              _ActionIcon(icon: Icons.favorite, label: video.likes.toString()),
              const SizedBox(height: 20),
              const _ActionIcon(icon: Icons.comment, label: '120'),
              const SizedBox(height: 20),
              const _ActionIcon(icon: Icons.share, label: 'Share'),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                video.description,
                style: const TextStyle(
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
}

class _VideoPlayer extends StatelessWidget {
  final CachedVideoPlayerPlus? player;

  const _VideoPlayer({required this.player});

  @override
  Widget build(BuildContext context) {
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
}

class _ProfilePic extends StatelessWidget {
  final String profilePic;

  const _ProfilePic({required this.profilePic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: profilePic.isNotEmpty
            ? Image.network(
                profilePic,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
              )
            : const Icon(Icons.person),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionIcon({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 36),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
