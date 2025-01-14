import 'package:drawee/data/dto/subject_dto.dart';
import 'package:drawee/domain/repositories/subject_repository.dart';

class CreateSubjectUsecase {
  final SubjectRepository _subjectRepository;

  CreateSubjectUsecase(this._subjectRepository);

  Future<void> execute(String topic, String subjectId) async {
    final subject =
        SubjectDTO(postsIds: [], topic: topic, subjectId: subjectId);
    await _subjectRepository.createSubject(subject);
  }
}
