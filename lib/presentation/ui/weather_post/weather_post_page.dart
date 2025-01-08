import 'package:flutter/material.dart';
import 'package:drawee/presentation/ui/widgets/post_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/domain/entities/post.dart';

enum WeatherType {
  all,
  sunny,
  rainy,
  cloudy,
  windy,
  snowy;

  String get label {
    switch (this) {
      case WeatherType.all:
        return '전체';
      case WeatherType.sunny:
        return '맑음';
      case WeatherType.rainy:
        return '비';
      case WeatherType.cloudy:
        return '구름';
      case WeatherType.windy:
        return '바람';
      case WeatherType.snowy:
        return '눈';
    }
  }
}

class WeatherPostPage extends StatefulWidget {
  const WeatherPostPage({super.key});

  @override
  State<WeatherPostPage> createState() => _WeatherPostPageState();
}

class _WeatherPostPageState extends State<WeatherPostPage> {
  WeatherType _selectedWeather = WeatherType.all;

  // 샘플 데이터 수정
  final List<Post> _samplePosts = [
    Post(
      postId: '1',
      userId: "pJkzPGlKDskC9ixJCqfI",
      content: "일기를 써보겠습니다. 두근두근",
      createdAt: DateTime.parse("2024-12-27T14:38:40.079328"),
      imageUrl: "https://picsum.photos/id/564/200/",
      likes: 3,
      title: "오늘의 그림 일기 704",
      weather: "windy",
      subjectId: "mpo4sBf7c4sgeqYaQnF4",
      comments: [
        Comment(
          content: "행복하세요 ^^",
          createdAt: DateTime.parse("2025-01-06T14:38:40.079265"),
          userId: "T0xML1Y6xCjGL4be2pG2",
        ),
        Comment(
          content: "행복하세요 ^^",
          createdAt: DateTime.parse("2025-01-07T14:38:40.079282"),
          userId: "pJkzPGlKDskC9ixJCqfI",
        ),
        Comment(
          content: "행복하세요 ^^",
          createdAt: DateTime.parse("2025-01-07T14:38:40.079311"),
          userId: "duQXfjcgHD29HSCgmDFm",
        ),
      ],
    ),
  ];

  // 현재 선택된 날씨에 따라 필터링된 포스트 목록을 반환
  List<Post> get _filteredPosts {
    if (_selectedWeather == WeatherType.all) {
      return _samplePosts;
    }
    return _samplePosts
        .where((post) => post.weather == _selectedWeather.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마음 날씨별 보기'),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: WeatherType.values.length,
              itemBuilder: (context, index) {
                final weather = WeatherType.values[index];
                final isSelected = _selectedWeather == weather;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.green
                              : AppColors.lightGray,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedWeather = weather;
                            });
                          },
                          icon: SvgPicture.asset(
                            'assets/icon/${weather.name}.svg',
                            colorFilter: ColorFilter.mode(
                              isSelected ? AppColors.white : AppColors.darkGray,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? AppColors.green : AppColors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPosts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: _filteredPosts[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
