// ignore_for_file: public_member_api_docs, sort_constructors_first
class Video {
  final String id;
  final String url;
  final String description;
  final int likes;
  final String username;
  final String profilePic;

  Video({
    required this.id,
    required this.url,
    required this.description,
    required this.likes,
    required this.username,
    this.profilePic = '',
  });

  factory Video.fromMap(Map<String, dynamic> data, String id) {
    return Video(
      id: id,
      url: data['url'] ?? '',
      description: data['description'] ?? '',
      likes: data['likes'] ?? 0,
      username: data['username'] ?? 'User',
      profilePic: data['profilePic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'description': description,
      'likes': likes,
      'username': username,
      'profilePic': profilePic,
    };
  }

  Video copyWith({
    String? id,
    String? url,
    String? description,
    int? likes,
    String? username,
    String? profilePic,
  }) {
    return Video(
      id: id ?? this.id,
      url: url ?? this.url,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
