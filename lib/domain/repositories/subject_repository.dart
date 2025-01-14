import 'package:drawee/domain/entities/subject.dart';

abstract interface class SubjectRepository {
  Future<Subject?> getSubject(String subjectId);
  Future<List<Subject>> getSubjects(String query);
}
