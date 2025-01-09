import 'package:drawee/constant/colors.dart';
import 'package:flutter/material.dart';

class SubjectSearchPage extends StatelessWidget {
  const SubjectSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
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
            // 제목
            Text(
              // 우선 bool로 처리했지만
              // 뷰모델에서 검색 결과가 없으면 오늘의 주제 띄우게 설정
              textEditingController.text == '' ? '오늘의 주제' : '검색 결과',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppColors.black,
              ),
            ),
            // 검색 결과 리스트뷰
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      // 임시 데이터
                      '#data',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.green,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
