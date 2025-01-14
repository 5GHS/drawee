import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/domain/repositories/subject_repository.dart';

class GetSubjectsUsecase {
  final SubjectRepository _repository;

  GetSubjectsUsecase(this._repository);

  Future<List<Subject>> execute(String query) {
    return _repository.getSubjects(query);
  }
}
