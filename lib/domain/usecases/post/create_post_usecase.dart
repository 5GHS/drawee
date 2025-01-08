import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _repository;

  CreatePostUseCase(this._repository);

  Future<void> execute(Post post) {
    return _repository.createPost(post);
  }
}
