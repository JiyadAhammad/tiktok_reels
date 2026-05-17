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
      body: PreloadPageView.builder(
        scrollDirection: Axis.vertical,
        preloadPagesCount: 3,
        itemCount: provider.videos.length,
        onPageChanged: (index) => context.read<ReelsProvider>().setPage(index),
        itemBuilder: (context, index) {
          final video = provider.videos[index];

          return VideoPlayerItem(
            video: video,
            index: index,
          );
        },
      ),
    );
  }
}
