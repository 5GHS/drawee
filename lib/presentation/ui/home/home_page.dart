import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/home/widgets/weather_box.dart';
import 'package:drawee/presentation/ui/subject_post/subject_post_page.dart';
import 'package:drawee/presentation/ui/weather_post/weather_post_page.dart';
import 'package:drawee/presentation/viewmodels/post_view_model.dart';
import 'package:drawee/presentation/viewmodels/recommend_subject_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(recommendSubjectViewModelProvider.notifier).getRecommendSubject();
    var recommendAsync = ref.read(recommendSubjectViewModelProvider);
    final recommendId = recommendAsync.when(
      data: (data) {
        if (data == null) {
          throw Error();
        }
        return data.subjectId;
      },
      error: (error, stackTrace) => 'error',
      loading: () => 'loading',
    );
    ref.read(postViewModelProvider.notifier).getPostsBySubject(recommendId);
    final postsAsync = ref.read(postViewModelProvider);

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
              // 오늘의 주제
              recommendAsync.when(
                data: (data) {
                  if (data == null) {
                    return const Text(
                      '오류가 발생하였습니다',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.darkGray,
                      ),
                    );
                  }
                  return Text(
                    '# ${data.topic}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.green,
                    ),
                  );
                },
                error: (error, stackTrace) => const Text(
                  '오류가 발생하였습니다',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.darkGray,
                  ),
                ),
                loading: () => const Text(
                  '로딩 중...',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.darkGray,
                  ),
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
                child: postsAsync.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Text('받아올 데이터가 null값입니다');
                    }
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                      children: data.map((element) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(element.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            // 게시글 제목
                            Text(
                              element.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                            ),
                            // 게시글 작성자
                            Text(
                              element.userId,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: AppColors.darkGray,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                  error: (error, stackTrace) => Container(),
                  loading: () => Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 0.7,
                          color: AppColors.darkGray,
                        )),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.darkGray,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '로딩 중...',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
