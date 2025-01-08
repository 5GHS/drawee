import 'package:drawee/data/dto/subject_dto.dart';

abstract interface class SubjectDataSource {
  Future<SubjectDTO> getSubjects(String value);
}
