import 'dart:async';
import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/presentation/providers/subject_providers.dart';
import 'package:drawee/presentation/viewmodels/recommend_subject_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectViewModel extends AsyncNotifier<List<Subject>> {
  @override
  FutureOr<List<Subject>> build() async {
    final subjectToday = await ref
        .read(recommendSubjectViewModelProvider.notifier)
        .getRecommendSubject();
    return subjectToday == null ? [] : [subjectToday];
  }

  // 오늘의 주제를 검색해서 상태값에 반영
  Future<void> getListOfSubjectToday() async {
    state = const AsyncValue.loading();
    try {
      final recommendSubject = await ref
          .read(recommendSubjectViewModelProvider.notifier)
          .getRecommendSubject();
      if (recommendSubject == null) {
        return;
      }
      state = await AsyncValue.guard(() => ref
              .read(getSubjectUsecaseProvider)
              .execute(recommendSubject.topic)
              .then((value) {
            if (value == null) return [];
            return [value];
          }));
    } catch (e) {
      print(e);
    }
  }

  // 검색어에 맞는 주제 리스트를 상태값에 반영
  Future<void> getSubjects(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(getSubjectsUsecaseProvider).excute(query));
  }

  // 주제 하나 검색
  Future<Subject?> getSubject(String query) async {
    return ref.read(getSubjectUsecaseProvider).execute(query);
  }
}

final subjectViewModelProvider =
    AsyncNotifierProvider<SubjectViewModel, List<Subject>>(
        () => SubjectViewModel());
