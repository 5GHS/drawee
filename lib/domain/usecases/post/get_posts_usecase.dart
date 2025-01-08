import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository _repository;

  GetPostsUseCase(this._repository);

  Future<List<Post>> execute() {
    return _repository.getPosts();
  }
}
