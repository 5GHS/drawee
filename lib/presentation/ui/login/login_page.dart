import 'package:drawee/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green, // 배경색 설정
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset('assets/images/login_page_logo.svg'),
          const Spacer(),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/images/login_page_small_logo.svg'),
                    const SizedBox(height: 16),
                    const Text(
                      '로그인해서 시작하기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '추억의 그림일기 SNS drawee를 이용하시려면\n로그인이 필요합니다.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 16),
                // 구글 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/icon/google_icon.png', // 구글 아이콘 이미지 경로
                      width: 24,
                      height: 24,
                    ),
                    label: const Text(
                      '구글 로그인',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.lightGray),
                      ),
                      splashFactory: NoSplash.splashFactory,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // 애플 로그인 버튼
                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       // TODO: 애플 로그인 구현
                //     },
                //     icon: const Icon(
                //       Icons.apple,
                //       color: Colors.white,
                //       size: 24,
                //     ),
                //     label: const Text(
                //       '애플 로그인',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.black,
                //       elevation: 0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
