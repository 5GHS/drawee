class Comment {
  final String content;
  final DateTime createdAt;
  final String userId;

  const Comment({
    required this.content,
    required this.createdAt,
    required this.userId,
  });
}

class Post {
  final String postId;
  final List<Comment> comments;
  final String content;
  final String userId;
  final String title;
  final String imageUrl;
  final String subjectId;
  final String weather;
  final int likes;
  final DateTime createdAt;

  const Post({
    required this.postId,
    required this.comments,
    required this.content,
    required this.userId,
    required this.title,
    required this.imageUrl,
    required this.subjectId,
    required this.weather,
    required this.likes,
    required this.createdAt,
  });

  Post copyWith({
    String? postId,
    List<Comment>? comments,
    String? content,
    String? userId,
    String? title,
    String? imageUrl,
    String? subjectId,
    String? weather,
    int? likes,
    DateTime? createdAt,
  }) {
    return Post(
      postId: postId ?? this.postId,
      comments: comments ?? this.comments,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      subjectId: subjectId ?? this.subjectId,
      weather: weather ?? this.weather,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
