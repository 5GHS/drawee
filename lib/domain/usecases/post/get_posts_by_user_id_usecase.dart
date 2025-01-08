import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class GetPostsByUserIdUseCase {
  final PostRepository _repository;

  GetPostsByUserIdUseCase(this._repository);

  Future<List<Post>> execute(String userId) {
    return _repository.getPostsByUserId(userId);
  }
}
