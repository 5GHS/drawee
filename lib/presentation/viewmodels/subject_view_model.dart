import 'dart:async';

import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/presentation/providers/subject_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectViewModel extends AsyncNotifier<List<Subject>> {
  @override
  FutureOr<List<Subject>> build() async {
    // 오늘의 주제 찾는 기능 완성하면
    // 빌드에서 ref.read(getSubjectUsecaseProvider).excute() 리턴하도록 수정
    return await ref.read(getSubjectsUsecaseProvider).excute('바');
  }

  Future<void> getSubjects(String query) async {
    state = await AsyncValue.guard(
        () => ref.read(getSubjectsUsecaseProvider).excute(query));
  }
}

final subjectViewModelProvider =
    AsyncNotifierProvider<SubjectViewModel, List<Subject>>(
        () => SubjectViewModel());
