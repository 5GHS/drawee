import 'dart:async';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/viewmodels/subject_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 게시글을 작성할 때 사용하는 주제 검색 페이지
// 주제 생성 기능을 포함합니다

class WriteSubjectSearchPage extends ConsumerStatefulWidget {
  const WriteSubjectSearchPage({super.key});

  @override
  ConsumerState<WriteSubjectSearchPage> createState() =>
      _WriteSubjectSearchPageState();
}

class _WriteSubjectSearchPageState
    extends ConsumerState<WriteSubjectSearchPage> {
  Timer? _debounce;
  final textEditingController = TextEditingController();

  // 오늘의 주제 조회
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(subjectViewModelProvider.notifier).getRecommendSubjects();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer(
          builder: (context, ref, child) {
            final subjectsAsync = ref.watch(subjectViewModelProvider);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------
                // 검색창
                // ------------------
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 2,
                      bottom: 2,
                    ),
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.lightGray,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 텍스트필드
                        Flexible(
                          child: TextField(
                            controller: textEditingController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '관심있는 주제를 검색해보세요',
                              hintStyle: TextStyle(color: AppColors.darkGray),
                            ),
                            onChanged: (query) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              _debounce =
                                  Timer(const Duration(milliseconds: 300), () {
                                if (textEditingController.text.isNotEmpty) {
                                  ref
                                      .read(subjectViewModelProvider.notifier)
                                      .getSubjects(query);
                                } else if (textEditingController.text.isEmpty) {
                                  ref
                                      .read(subjectViewModelProvider.notifier)
                                      .getRecommendSubjects();
                                }
                              });
                            },
                          ),
                        ),
                        // 검색 버튼
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 40,
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.search,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // ------------------
                // 검색 결과
                // ------------------
                // 제목
                const Text(
                  '검색 결과',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.black,
                  ),
                ),
                // 검색 결과 리스트
                subjectsAsync.when(
                  data: (subjects) {
                    return SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: GestureDetector(
                              // 주제를 선택하면 topic과 subjectId를 pop으로 반환
                              onTap: () {
                                Navigator.pop(context, {
                                  'topic': subjects[index].topic,
                                  'subjectId': subjects[index].subjectId,
                                });
                              },
                              child: Text(
                                '# ${subjects[index].topic}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: AppColors.green,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stack) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '오류가 발생했습니다.',
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 12,
                          color: AppColors.darkGray,
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '로딩 중...',
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 16,
                          color: AppColors.darkGray,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
