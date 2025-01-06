import 'package:flutter/material.dart';

class MypagePage extends StatelessWidget {
  const MypagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 제목 1 - 마음 날씨별 보기
                  const Text(
                    '마음 날씨별 보기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  // 페이지 이동 아이콘
                  GestureDetector(
                    onTap: () {
                      print('tap');
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.centerRight,
                      color: Colors.transparent,
                      child: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
