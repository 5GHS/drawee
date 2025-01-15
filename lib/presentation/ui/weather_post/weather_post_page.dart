import 'package:drawee/presentation/viewmodels/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drawee/presentation/ui/widgets/post_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/providers/post_providers.dart';

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

class WeatherPostPage extends ConsumerStatefulWidget {
  final String? fromHome;

  const WeatherPostPage({
    super.key,
    this.fromHome,
  });

  @override
  ConsumerState<WeatherPostPage> createState() => _WeatherPostPageState();
}

class _WeatherPostPageState extends ConsumerState<WeatherPostPage> {
  WeatherType _selectedWeather = WeatherType.all;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (widget.fromHome != null) {
    //     final selectedWeather = WeatherType.values.firstWhere(
    //       (weather) => weather.label == widget.fromHome,
    //       orElse: () => WeatherType.all,
    //     );

    //     setState(() {
    //       _selectedWeather = selectedWeather;
    //     });

    //     ref
    //         .watch(postViewModelProvider.notifier)
    //         .getPostsByWeather(selectedWeather.label);
    //   } else {
    //     setState(() {
    //       _selectedWeather = WeatherType.all;
    //     });

    //     ref.read(postViewModelProvider.notifier).getPosts();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '마음 날씨별 보기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: WeatherType.values.map((weather) {
                  final isSelected = _selectedWeather == weather;
                  return Column(
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
                            if (weather == WeatherType.all) {
                              ref
                                  .read(postViewModelProvider.notifier)
                                  .getPosts();
                            } else {
                              ref
                                  .read(postViewModelProvider.notifier)
                                  .getPostsByWeather(weather.name);
                            }
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
                      const SizedBox(height: 4),
                      Text(
                        weather.label,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isSelected ? AppColors.green : AppColors.darkGray,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const Divider(
              height: 1,
              color: AppColors.lightGray,
            ),
            Expanded(
              child: postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return const Center(
                      child: Text('포스트가 없습니다.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: posts[index]);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
