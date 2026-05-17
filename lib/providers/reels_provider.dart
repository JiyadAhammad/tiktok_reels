import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video.dart';
import '../services/video_service.dart';

class ReelsProvider extends ChangeNotifier {
  final VideoService _videoService = VideoService();
  List<Video> videos = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  bool hasMore = true;
  DocumentSnapshot? _lastDoc;
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
    hasMore = true;
    notifyListeners();
    
    final result = await _videoService.fetchVideos(limit: 5);
    videos = result.$1;
    _lastDoc = result.$2;
    
    if (videos.length < 5 || _lastDoc == null) {
      hasMore = false;
    }
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreVideos() async {
    if (isFetchingMore || !hasMore) return;
    
    isFetchingMore = true;
    notifyListeners();
    
    final result = await _videoService.fetchVideos(lastDoc: _lastDoc, limit: 5);
    final newVideos = result.$1;
    _lastDoc = result.$2;
    
    if (newVideos.isEmpty) {
      hasMore = false;
    } else {
      videos.addAll(newVideos);
      if (newVideos.length < 5) {
        hasMore = false;
      }
    }
    
    isFetchingMore = false;
    notifyListeners();
  }

  void setPage(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      notifyListeners();
      
      // Load more when reaching near the end
      if (index >= videos.length - 2) {
        loadMoreVideos();
      }
    }
  }
}
