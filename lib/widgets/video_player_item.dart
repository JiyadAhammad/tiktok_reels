import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';
import '../providers/reels_provider.dart';
import '../providers/video_item_provider.dart';

class VideoPlayerItem extends StatelessWidget {
  final Video video;
  final int index;

  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<ReelsProvider, VideoItemProvider>(
      create: (_) => VideoItemProvider(url: video.url, index: index),
      update: (context, reelsProvider, itemProvider) {
        itemProvider!.updateActiveState(reelsProvider.currentIndex == index);
        return itemProvider;
      },
      child: Stack(
        children: [
          // Video Player Background
          const Positioned.fill(child: _VideoPlayer()),

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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlayer extends StatelessWidget {
  const _VideoPlayer();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoItemProvider>();

    if (provider.player == null || !provider.isInitialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: provider.togglePlay,
      child: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: provider.player!.controller.value.aspectRatio,
            // We use CachedVideoPlayer as per cached_video_player_plus if it exposes it,
            // or if it exposes a normal VideoPlayerController, VideoPlayer is fine.
            child: VideoPlayer(provider.player!.controller),
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
            ? CachedNetworkImage(
                imageUrl: profilePic,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white24,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              )
            : const Icon(Icons.person),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 36),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
