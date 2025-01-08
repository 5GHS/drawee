import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository _repository;

  UpdatePostUseCase(this._repository);

  Future<void> execute(Post post) {
    return _repository.updatePost(post);
  }
}
