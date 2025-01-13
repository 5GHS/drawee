import 'dart:async';
import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/presentation/providers/subject_providers.dart';
import 'package:drawee/presentation/viewmodels/recommend_subject_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectViewModel extends AsyncNotifier<List<Subject>> {
  @override
  FutureOr<List<Subject>> build() async {
    return [];
  }

  // 오늘의 주제를 검색해서 상태값에 반영
  // 사용x
  Future<void> getRecommendSubjects() async {
    try {
      final recommend = await ref
          .read(recommendSubjectViewModelProvider.notifier)
          .getRecommendSubject();

      if (recommend != null) {
        state = await AsyncValue.guard(
          () => ref
              .read(getSubjectUsecaseProvider)
              .execute(recommend.subjectId)
              .then(
            (value) {
              if (value == null) return [];
              return [value];
            },
          ),
        );
      } else {
        print('response is null');
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
  }

  // 검색어에 맞는 주제 리스트를 상태값에 반영
  Future<void> getSubjects(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(getSubjectsUsecaseProvider).execute(query));
  }

  // 주제 검색
  Future<Subject?> getSubject(String query) async {
    return ref.read(getSubjectUsecaseProvider).execute(query);
  }
}

final subjectViewModelProvider =
    AsyncNotifierProvider<SubjectViewModel, List<Subject>>(
        () => SubjectViewModel());
