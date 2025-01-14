import 'package:drawee/data/dto/post_dto.dart';

abstract interface class PostDataSource {
  Future<PostDTO?> getPost(String postId);
  Future<List<PostDTO>> getPosts();
  Future<List<PostDTO>> getPostsByWeather(String weather);
  Future<List<PostDTO>> getPostsBySubjectId(String subjectId);
  Future<List<PostDTO>> getPostsByUserId(String userId);
  Future<List<PostDTO>> getPostsByIds(List<String> postIds);
  Future<bool> createPost(Map<String, dynamic> data);
  Future<bool> updatePost(String postId, Map<String, dynamic> data);
  Future<bool> deletePost(String postId);
}
