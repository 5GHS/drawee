import 'package:drawee/domain/entities/recommend_subject.dart';

abstract interface class RecommendSubjectRepository {
  Future<RecommendSubject?> getRecommendSubject(int subjectIndex);
}
