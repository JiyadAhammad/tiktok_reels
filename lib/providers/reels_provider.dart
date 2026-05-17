import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/video_service.dart';

class ReelsProvider extends ChangeNotifier {
  final VideoService _videoService = VideoService();
  List<Video> videos = [];
  bool isLoading = true;
  int currentIndex = 0;

  ReelsProvider() {
    loadVideos();
  }

  Future<void> uploadVideo() async {
    for (var item in _videoService.getMockVideos()) {
      item = item.copyWith(id: "${DateTime.now().millisecondsSinceEpoch}");
      await _videoService.uploadVideo(item);
    }
  }

  Future<void> loadVideos() async {
    isLoading = true;
    notifyListeners();
    videos = await _videoService.fetchVideos();
    isLoading = false;
    notifyListeners();
  }

  void setPage(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      notifyListeners();
    }
  }
}
