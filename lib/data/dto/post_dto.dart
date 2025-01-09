import 'package:drawee/domain/entities/post.dart';

class CommentDTO {
  final String content;
  final DateTime createdAt;
  final String userId;

  CommentDTO({
    required this.content,
    required this.createdAt,
    required this.userId,
  });

  factory CommentDTO.fromJson(Map<String, dynamic> json) {
    return CommentDTO(
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
    );
  }
}

class PostDTO {
  final String id;
  final List<CommentDTO> comments;
  final String content;
  final String userId;
  final String title;
  final String imageUrl;
  final String subjectId;
  final String weather;
  final int likes;
  final DateTime createdAt;

  PostDTO({
    required this.id,
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

  factory PostDTO.fromJson(Map<String, dynamic> json, String documentId) {
    return PostDTO(
      id: documentId,
      comments: (json['comments'] as List<dynamic>)
          .map(
              (comment) => CommentDTO.fromJson(comment as Map<String, dynamic>))
          .toList(),
      content: json['content'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      subjectId: json['subjectId'] as String,
      weather: json['weather'] as String,
      likes: json['likes'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Post toEntity() {
    return Post(
      postId: id,
      comments: comments
          .map((comment) => Comment(
                content: comment.content,
                createdAt: comment.createdAt,
                userId: comment.userId,
              ))
          .toList(),
      content: content,
      userId: userId,
      title: title,
      imageUrl: imageUrl,
      subjectId: subjectId,
      weather: weather,
      likes: likes,
      createdAt: createdAt,
    );
  }
}
