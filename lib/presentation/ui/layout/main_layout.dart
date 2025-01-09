import 'package:drawee/presentation/ui/write_post/write_post_page.dart';
import 'package:flutter/material.dart';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/home/home_page.dart';
import 'package:drawee/presentation/ui/weather_post/weather_post_page.dart';
import 'package:drawee/presentation/ui/subject_post/subject_post_page.dart';
import 'package:drawee/presentation/ui/mypage/mypage_page.dart';
import 'package:flutter_svg/svg.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const WeatherPostPage(),
    const WritePostPage(),
    const SubjectPostPage(),
    const MypagePage(),
  ];

// TODO : 디자인 디테일 잡아야함
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.gray,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/home_selected.svg')
                : SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/home.svg'),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/weather_selected.svg')
                : SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/weather.svg'),
            label: '날씨별',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/write_selected.svg')
                : SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/write.svg'),
            label: '글쓰기',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/subject_selected.svg')
                : SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/subject.svg'),
            label: '주제별',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 4
                ? SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/profile_selected.svg')
                : SvgPicture.asset(
                    'assets/icon/bottom_navigation_icons/profile.svg'),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
