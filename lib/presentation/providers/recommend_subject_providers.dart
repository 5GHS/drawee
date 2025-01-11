import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/data/data_sources/firebase_recommend_subject_data_source.dart';
import 'package:drawee/data/repositories/recommend_subject_repository_impl.dart';
import 'package:drawee/domain/usecases/recommend_subject/get_recommend_subject_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _recommendSubjectDataSourceProvider = Provider((ref) {
  return FirebaseRecommendSubjectDataSource(FirebaseFirestore.instance);
});

final _recommendSubjectRepositoryProvider = Provider((ref) {
  return RecommendSubjectRepositoryImpl(
      ref.watch(_recommendSubjectDataSourceProvider));
});

final getRecommendSubjectUsecaseProvider = Provider((ref) {
  return GetRecommendSubjectUsecase(
      ref.watch(_recommendSubjectRepositoryProvider));
});
