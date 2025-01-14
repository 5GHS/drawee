import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/domain/repositories/subject_repository.dart';

class GetSubjectUsecase {
  final SubjectRepository _repository;

  GetSubjectUsecase(this._repository);

  Future<Subject?> execute(String subjectId) {
    return _repository.getSubject(subjectId);
  }
}
