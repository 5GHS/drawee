import 'package:drawee/data/dto/post_response_dto.dart';

abstract interface class PostDataSource {
  Future<PostResponseDTO?> getPost(String postId);
  Future<List<PostResponseDTO>> getPosts();
  Future<List<PostResponseDTO>> getPostsByWeather(String weather);
  Future<List<PostResponseDTO>> getPostsBySubjectId(String subjectId);
  Future<List<PostResponseDTO>> getPostsByUserId(String userId);
  Future<void> createPost(Map<String, dynamic> data);
  Future<void> updatePost(String postId, Map<String, dynamic> data);
  Future<void> deletePost(String postId);
}
