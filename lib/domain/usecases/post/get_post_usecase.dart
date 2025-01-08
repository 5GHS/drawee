import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class GetPostUseCase {
  final PostRepository _repository;

  GetPostUseCase(this._repository);

  Future<Post?> execute(String postId) {
    return _repository.getPost(postId);
  }
}
