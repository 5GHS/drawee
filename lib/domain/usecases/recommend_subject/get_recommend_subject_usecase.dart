import 'package:drawee/domain/entities/recommend_subject.dart';
import 'package:drawee/domain/repositories/recommend_subject_repository.dart';

class GetRecommendSubjectUsecase {
  final RecommendSubjectRepository _repository;

  GetRecommendSubjectUsecase(this._repository);

  Future<RecommendSubject?> excute(int subjectIndex) async {
    return _repository.getRecommendSubject(subjectIndex);
  }
}
