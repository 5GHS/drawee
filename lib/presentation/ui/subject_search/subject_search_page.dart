import 'package:drawee/constant/colors.dart';
import 'package:drawee/constant/text_pattern.dart';
import 'package:drawee/domain/entities/subject.dart';
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
    List<Subject> subjectList = [];
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer(
          builder: (context, ref, child) {
            var viewmodel = ref.read(subjectViewModelProvider.notifier);
            viewmodel.getRecommendSubjects();
            final subjectsAsync = ref.watch(subjectViewModelProvider);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              if (query.isNotEmpty &&
                                  textPattern.hasMatch(query.trim())) {
                                viewmodel.getSubjects(query);
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
                textEditingController.text.isNotEmpty && subjectList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 0.5,
                              color: AppColors.gray,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColors.darkGray,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '검색 결과가 없습니다.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColors.darkGray),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 20,
                      ),
                // 검색 결과 리스트뷰
                textEditingController.text.isEmpty || subjectList.isEmpty
                    ? const Text(
                        '오늘의 주제',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.black,
                        ),
                      )
                    : const Text(
                        '검색 결과',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.black,
                        ),
                      ),
                subjectsAsync.when(
                  data: (subjects) {
                    subjectList = subjects;
                    return SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: subjectList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '# ${subjectList[index].topic}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppColors.green,
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
