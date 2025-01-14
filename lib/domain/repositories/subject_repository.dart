import 'package:drawee/data/dto/subject_dto.dart';
import 'package:drawee/domain/entities/subject.dart';

abstract interface class SubjectRepository {
  Future<Subject?> getSubject(String query);
  Future<List<Subject>> getSubjects(String query);
  Future<void> createSubject(SubjectDTO subject);
}
