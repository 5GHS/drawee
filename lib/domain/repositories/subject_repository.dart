import 'package:drawee/add_mock_data.dart';

abstract interface class SubjectRepository {
  Future<Subject?> getSubject(String query);
  Future<List<Subject>> getSubjects(String query);
}
