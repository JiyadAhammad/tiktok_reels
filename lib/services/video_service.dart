import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/video.dart';

class VideoService {
  final FirebaseFirestore? _db;

  VideoService() : _db = _getFirestore();

  static FirebaseFirestore? _getFirestore() {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseFirestore.instance;
      }
    } catch (e) {
      // Firebase not initialized
    }
    return null;
  }

  Future<void> uploadVideo(Video video) async {
    if (_db == null) {
      return;
    }
    try {
      await _db.collection('videos').doc(video.id).set(video.toMap());

      print('Video uploaded successfully');
    } catch (e) {
      print('Error uploading video: $e');
    }
  }

  // Fetch videos from Firestore or use mock data if Firebase is not setup
  Future<(List<Video>, DocumentSnapshot?)> fetchVideos({
    DocumentSnapshot? lastDoc,
    int limit = 5,
  }) async {
    if (_db != null) {
      try {
        Query query = _db.collection('videos').limit(limit);
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
        final snapshot = await query.get();
        if (snapshot.docs.isNotEmpty) {
          final videos = snapshot.docs
              .map(
                (doc) =>
                    Video.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();
          return (videos, snapshot.docs.last);
        } else {
          return (<Video>[], lastDoc);
        }
      } catch (e) {
        print('Error fetching from Firestore: $e');
      }
    }

    // Fallback to Mock Data
    print('Falling back to mock videos.');
    return (lastDoc == null ? getMockVideos() : <Video>[], null);
  }

  List<Video> getMockVideos() {
    return [
      Video(
        id: '1',
        url:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        description: 'Beautiful butterfly in nature #nature #butterfly',
        likes: 1200,
        username: '@nature_lover',
        profilePic: 'https://picsum.photos/200',
      ),
      Video(
        id: '2',
        url:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        description: 'Busy bee collecting pollen #bee #flowers',
        likes: 3450,
        username: '@insect_world',
        profilePic: 'https://picsum.photos/201',
      ),
      Video(
        id: '3',
        url: 'https://www.w3schools.com/html/mov_bbb.mp4',
        description: 'Big Buck Bunny! #animation #blender',
        likes: 890,
        username: '@funny_bunny',
        profilePic: 'https://picsum.photos/202',
      ),
      Video(
        id: '4',
        url: 'https://www.w3schools.com/html/movie.mp4',
        description: 'Bear animation walking around #bear #wildlife',
        likes: 5600,
        username: '@bear_grylls',
        profilePic: 'https://picsum.photos/203',
      ),
      Video(
        id: '5',
        url:
            'https://raw.githubusercontent.com/mdn/learning-area/master/html/multimedia-and-embedding/video-and-audio-content/rabbit320.mp4',
        description: 'Rabbit hopping! #rabbit #cute',
        likes: 15200,
        username: '@cute_animals',
        profilePic: 'https://picsum.photos/204',
      ),
    ];
  }
}
