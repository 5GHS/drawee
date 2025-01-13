import 'package:drawee/data/dto/recommend_subject_dto.dart';

abstract interface class RecommendSubjectDataSource {
  Future<RecommendSubjectDTO?> getRecommendSubject(int subjectIndex);
}
