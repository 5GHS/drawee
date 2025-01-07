import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/home/widgets/weather_box.dart';
import 'package:drawee/presentation/ui/subject_post/subject_post_page.dart';
import 'package:drawee/presentation/ui/weather_post/weather_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // GridView.counter에 넣을 그림 목록 (임시 데이터)
  final List<String> postList = [
    'assets/images/weather_all.jpeg',
    'assets/images/weather_all.jpeg',
    'assets/images/weather_all.jpeg',
    'assets/images/weather_all.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SvgPicture.asset('assets/images/mypage_page_logo.svg'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              // 제목 1 - 마음 날씨별 보기
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '마음 날씨별 보기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.black,
                    ),
                  ),
                  // 페이지 이동 아이콘
                  GestureDetector(
                    onTap: () {
                      print('tap');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherPostPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.centerRight,
                      color: Colors.transparent,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              // 날씨 박스
              const Row(
                children: [
                  WeatherBox('전체', 'assets/images/weather_all.jpeg'),
                  SizedBox(width: 12),
                  WeatherBox('맑음', 'assets/images/weather_clear.jpeg'),
                  SizedBox(width: 12),
                  WeatherBox('비', 'assets/images/weather_rainy.jpeg'),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Row(
                children: [
                  WeatherBox('흐림', 'assets/images/weather_cloudy.jpeg'),
                  SizedBox(width: 12),
                  WeatherBox('바람', 'assets/images/weather_windy.jpeg'),
                  SizedBox(width: 12),
                  WeatherBox('눈', 'assets/images/weather_snowy.jpeg'),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              // 제목 2 - 오늘의 주제 보기
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '오늘의 주제',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.black,
                    ),
                  ),
                  // 페이지 이동 아이콘
                  GestureDetector(
                    onTap: () {
                      print('tap');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectPostPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.centerRight,
                      color: Colors.transparent,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              // TODO : 오늘의 주제 변수로 변경
              const Text(
                '#오늘의 주제',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              // 주제별 아이템
              Container(
                width: double.infinity,
                height: 330,
                alignment: Alignment.center,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.80,
                  children: postList.map(
                    (String path) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 176,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          // 게시글 제목
                          const Text(
                            '제목',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                          // 게시글 작성자
                          const Text(
                            '작성자',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: AppColors.darkGray),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
