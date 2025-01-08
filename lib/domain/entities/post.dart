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
}
