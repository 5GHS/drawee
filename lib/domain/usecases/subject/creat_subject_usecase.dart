import 'package:drawee/domain/repositories/subject_repository.dart';

class CreateSubjectUsecase {
  final SubjectRepository _subjectRepository;

  CreateSubjectUsecase(this._subjectRepository);

  Future<void> execute(String topic) async {
    await _subjectRepository.createSubject(topic);
  }
}
