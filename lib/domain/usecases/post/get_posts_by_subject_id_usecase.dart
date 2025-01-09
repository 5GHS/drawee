import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class GetPostsBySubjectIdUseCase {
  final PostRepository _repository;

  GetPostsBySubjectIdUseCase(this._repository);

  Future<List<Post>> execute(String subjectId) {
    return _repository.getPostsBySubjectId(subjectId);
  }
}
