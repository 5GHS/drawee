import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class GetPostsByIdsUseCase {
  final PostRepository _repository;

  GetPostsByIdsUseCase(this._repository);

  Future<List<Post>> execute(List<String> postIds) {
    return _repository.getPostsByIds(postIds);
  }
}
