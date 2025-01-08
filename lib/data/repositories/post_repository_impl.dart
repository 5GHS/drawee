import 'package:drawee/data/data_sources/post_data_source.dart';
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
  Future<void> createPost(Post post) async {
    final data = {
      'content': post.content,
      'userId': post.userId,
      'title': post.title,
      'imageUrl': post.imageUrl,
      'subjectId': post.subjectId,
      'weather': post.weather,
      'likes': post.likes,
      'createdAt': post.createdAt.toIso8601String(),
      'comments': post.comments
          .map((comment) => {
                'content': comment.content,
                'userId': comment.userId,
                'createdAt': comment.createdAt.toIso8601String(),
              })
          .toList(),
    };
    await _postDataSource.createPost(data);
  }

  @override
  Future<void> updatePost(Post post) async {
    final data = {
      'content': post.content,
      'title': post.title,
      'imageUrl': post.imageUrl,
      'weather': post.weather,
      // 업데이트 시에는 일부 필드만 변경 가능하도록 제한
    };
    await _postDataSource.updatePost(post.postId, data);
  }

  @override
  Future<void> deletePost(String postId) async {
    await _postDataSource.deletePost(postId);
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
}
