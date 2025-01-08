import 'package:drawee/data/dto/subject_dto.dart';

abstract interface class SubjectDataSource {
  Future<List<SubjectDTO>> getSubjects(String value);
}
