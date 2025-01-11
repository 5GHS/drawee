import 'dart:async';
import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/presentation/providers/recommend_subject_providers.dart';
import 'package:drawee/presentation/providers/subject_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// RecommendSubjectViewModel에서 오늘의 주제 관리
// R.S > S 로 변환은 추후로 미루지 말고, RecommendSubject가 정해지는대로 이루어져야 함
// 이유 : 홈 페이지에서도 <Subject>postsIds 배열을 참조하여 포스트 목록을 생성해야 하기 때문
// 이 뷰모델에서 관리하는 대상은 Subject로 정함

class RecommendSubjectViewModel extends AsyncNotifier<Subject?> {
  @override
  FutureOr<Subject?> build() {
    return getTodaySubject();
  }

  Future<Subject?> getTodaySubject() async {
    state = const AsyncValue.loading();
    final int date = DateTime.now().day;
    try {
      final todayRecommendSubject =
          await ref.watch(getRecommendSubjectUsecaseProvider).excute(date);

      if (todayRecommendSubject != null) {
        final todayTopic = todayRecommendSubject.topic;
        state = await AsyncValue.guard(
            () => ref.watch(getSubjectUsecaseProvider).execute(todayTopic));
      }
      return null;
    } catch (e, stack) {
      print(e);
      print(stack);
      return null;
    }
  }

  final recommendSubjectViewModelProvider =
      AsyncNotifierProvider<RecommendSubjectViewModel, Subject?>(
          () => RecommendSubjectViewModel());
}
