import 'package:drawee/data/data_sources/post_data_source.dart';
import 'package:drawee/data/dto/post_dto.dart';
import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource _postDataSource;

  PostRepositoryImpl(this._postDataSource);

  @override
  Future<Post?> getPost(String postId) async {
    final dto = await _postDataSource.getPost(postId);
    if (dto == null) return null;
    return dto.toEntity();
  }

  @override
  Future<List<Post>> getPosts() async {
    final dtos = await _postDataSource.getPosts();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Post>> getPostsByWeather(String weather) async {
    final dtos = await _postDataSource.getPostsByWeather(weather);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<bool> createPost(Post post) async {
    final dto = PostDTO.fromEntity(post);
    return await _postDataSource.createPost(dto.toJson());
  }

  @override
  Future<bool> updatePost(Post post) async {
    final data = {
      'content': post.content,
      'title': post.title,
      'imageUrl': post.imageUrl,
      'weather': post.weather,
    };
    return await _postDataSource.updatePost(post.postId, data);
  }

  @override
  Future<bool> deletePost(String postId) async {
    return await _postDataSource.deletePost(postId);
  }

  @override
  Future<List<Post>> getPostsBySubjectId(String subjectId) async {
    final dtos = await _postDataSource.getPostsBySubjectId(subjectId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Post>> getPostsByUserId(String userId) async {
    final dtos = await _postDataSource.getPostsByUserId(userId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Post>> getPostsByIds(List<String> postIds) async {
    final dtos = await _postDataSource.getPostsByIds(postIds);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
