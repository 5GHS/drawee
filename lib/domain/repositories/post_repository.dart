import 'package:drawee/domain/entities/post.dart';

abstract interface class PostRepository {
  Future<Post?> getPost(String postId);
  Future<List<Post>> getPosts();
  Future<List<Post>> getPostsByWeather(String weather);
  Future<List<Post>> getPostsBySubjectId(String subjectId);
  Future<List<Post>> getPostsByUserId(String userId);
  Future<bool> createPost(Post post);
  Future<bool> updatePost(Post post);
  Future<bool> deletePost(String postId);
}
