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

  // Fetch videos from Firestore or use mock data if Firebase is not setup
  Future<List<Video>> fetchVideos() async {
    if (_db != null) {
      try {
        final snapshot = await _db!.collection('videos').get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.map((doc) => Video.fromMap(doc.data(), doc.id)).toList();
        }
      } catch (e) {
        print('Error fetching from Firestore: $e');
      }
    }
    
    // Fallback to Mock Data
    print('Falling back to mock videos.');
    return _getMockVideos();
  }

  List<Video> _getMockVideos() {
    return [
      Video(
        id: '1',
        url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        description: 'Beautiful blazing fire #fire #nature',
        likes: 1200,
        username: '@fire_lover',
        profilePic: 'https://picsum.photos/200',
      ),
      Video(
        id: '2',
        url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        description: 'The great escape! #adventure #travel',
        likes: 3450,
        username: '@traveler_joe',
        profilePic: 'https://picsum.photos/201',
      ),
      Video(
        id: '3',
        url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        description: 'Having some fun! #fun #smile',
        likes: 890,
        username: '@funny_guy',
        profilePic: 'https://picsum.photos/202',
      ),
      Video(
        id: '4',
        url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        description: 'Joyride across the country #cars #roadtrip',
        likes: 5600,
        username: '@car_enthusiast',
        profilePic: 'https://picsum.photos/203',
      ),
      Video(
        id: '5',
        url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
        description: 'Wait for it... #funny #lol',
        likes: 15200,
        username: '@meme_lord',
        profilePic: 'https://picsum.photos/204',
      ),
    ];
  }
}
