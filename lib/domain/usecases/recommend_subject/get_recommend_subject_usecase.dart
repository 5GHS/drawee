import 'package:drawee/domain/entities/recommend_subject.dart';
import 'package:drawee/domain/repositories/recommend_subject_repository.dart';

class GetRecommendSubjectUsecase {
  final RecommendSubjectRepository _repository;

  GetRecommendSubjectUsecase(this._repository);

  Future<RecommendSubject?> execute() async {
    int date = DateTime.now().day;
    return _repository.getRecommendSubject(date);
  }
}
