import 'package:drawee/data/data_sources/subject_data_source.dart';
import 'package:drawee/data/dto/subject_dto.dart';
import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/domain/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectDataSource _subjectDataSource;

  SubjectRepositoryImpl(this._subjectDataSource);

  // subjectId와 일치하는 Subject 객체를 찾는 함수
  @override
  Future<Subject?> getSubject(String subjectId) async {
    final dto = await _subjectDataSource.getSubject(subjectId);
    if (dto == null) return null;
    return dto.toEntity();
  }

  // query를 포함하는 Subject의 리스트를 찾는 함수
  @override
  Future<List<Subject>> getSubjects(String query) async {
    final dtos = await _subjectDataSource.getSubjects(query);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> createSubject(String topic) {
    return _subjectDataSource.createSubject(topic);
  }
}
