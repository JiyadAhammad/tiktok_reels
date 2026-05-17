import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import '../providers/reels_provider.dart';
import '../widgets/video_player_item.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReelsProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (provider.videos.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No videos available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PreloadPageView.builder(
            scrollDirection: Axis.vertical,
            preloadPagesCount: 3,
            itemCount: provider.videos.length + (provider.hasMore ? 1 : 0),
            onPageChanged: (index) {
              // If we reach the loading page, we still want to update the provider
              context.read<ReelsProvider>().setPage(index);
            },
            itemBuilder: (context, index) {
              if (index == provider.videos.length) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              final video = provider.videos[index];

              return VideoPlayerItem(video: video, index: index);
            },
          ),
          if (provider.isFetchingMore)
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SafeArea(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
