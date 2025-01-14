import 'package:drawee/data/dto/subject_dto.dart';
import 'package:drawee/domain/entities/subject.dart';

abstract interface class SubjectDataSource {
  Future<SubjectDTO?> getSubject(String query);
  Future<List<SubjectDTO>> getSubjects(String value);
  Future<void> createSubject(Subject subject);
}
