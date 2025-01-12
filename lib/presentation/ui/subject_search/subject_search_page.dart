import 'package:drawee/constant/colors.dart';
import 'package:drawee/constant/text_pattern.dart';
import 'package:drawee/presentation/viewmodels/subject_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectSearchPage extends StatefulWidget {
  const SubjectSearchPage({super.key});

  @override
  State<SubjectSearchPage> createState() => _SubjectSearchPageState();
}

class _SubjectSearchPageState extends State<SubjectSearchPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer(
          builder: (context, ref, child) {
            final viewModel = ref.watch(subjectViewModelProvider.notifier);
            viewModel.build();
            final subjectsAsync = ref.watch(subjectViewModelProvider);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                // 검색창
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
                              if (textEditingController.text.isNotEmpty &&
                                  textPattern
                                      .hasMatch(textEditingController.text)) {
                                viewModel.getSubjects(query);
                                print('search');
                              } else if (query.isEmpty) {
                                viewModel.getListOfSubjectToday();
                              }
                            },
                          ),
                        ),
                        // 검색 버튼
                        GestureDetector(
                          onTap: () {
                            print('tap');
                          },
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
                // 검색 결과 리스트뷰
                subjectsAsync.when(
                  data: (subjects) {
                    if (subjects.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '검색 결과',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 500,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              itemCount: subjects.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    // 임시 데이터
                                    '# ${subjects[index].topic}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: AppColors.green,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Column(
                        children: [
                          Text(
                            '오늘의 주제',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                  error: (error, stack) {
                    return Text('error');
                  },
                  loading: () {
                    return Text('loading');
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
