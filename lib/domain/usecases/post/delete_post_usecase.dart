import 'package:drawee/domain/repositories/post_repository.dart';

class DeletePostUseCase {
  final PostRepository _repository;

  DeletePostUseCase(this._repository);

  Future<void> execute(String postId) {
    return _repository.deletePost(postId);
  }
}
