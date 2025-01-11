import 'package:drawee/data/data_sources/recommend_subject_data_source.dart';
import 'package:drawee/domain/entities/recommend_subject.dart';
import 'package:drawee/domain/repositories/recommend_subject_repository.dart';

class RecommendSubjectRepositoryImpl implements RecommendSubjectRepository {
  final RecommendSubjectDataSource _recommendSubjectDataSource;

  RecommendSubjectRepositoryImpl(this._recommendSubjectDataSource);

  @override
  Future<RecommendSubject?> getRecommendSubject(int subjectIndex) async {
    final dto =
        await _recommendSubjectDataSource.getRecommendSubject(subjectIndex);
    if (dto == null) return null;
    return dto.toEntity();
  }
}
