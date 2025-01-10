import 'package:drawee/data/data_sources/algolia_subject_data_source.dart';
import 'package:drawee/data/data_sources/subject_data_source.dart';
import 'package:drawee/data/repositories/subject_repository_impl.dart';
import 'package:drawee/domain/repositories/subject_repository.dart';
import 'package:drawee/domain/usecases/subject/get_subjects_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _subjectDataSourceProvider = Provider<SubjectDataSource>((ref) {
  return AlgoliaSubjectDataSource();
});

final _subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return SubjectRepositoryImpl(ref.watch(_subjectDataSourceProvider));
});

final getSubjectsUsecaseProvider = Provider<GetSubjectsUsecase>((ref) {
  return GetSubjectsUsecase(ref.watch(_subjectRepositoryProvider));
});
