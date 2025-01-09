import 'package:drawee/data/data_sources/subject_data_source.dart';
import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/domain/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectDataSource _subjectDataSource;

  SubjectRepositoryImpl(this._subjectDataSource);

  @override
  Future<Subject?> getSubject(String query) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Subject>> getSubjects(String query) async {
    final dtos = await _subjectDataSource.getSubjects(query);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
