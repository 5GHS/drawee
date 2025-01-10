import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/domain/repositories/subject_repository.dart';

class GetSubjectsUsecase {
  final SubjectRepository _subjectRepository;

  GetSubjectsUsecase(this._subjectRepository);

  Future<List<Subject>> excute(String query) async {
    return _subjectRepository.getSubjects(query);
  }
}
