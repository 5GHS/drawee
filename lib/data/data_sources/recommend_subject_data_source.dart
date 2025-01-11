import 'package:drawee/domain/entities/recommend_subject.dart';

abstract interface class RecommendSubjectDataSource {
  Future<RecommendSubject?> getRecommendSubject(String query);
}
