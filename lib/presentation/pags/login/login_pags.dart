import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6BCF97), // 배경색 설정
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Icon(
            Icons.tag, // 아이콘 변경 필요 (커스텀 로고 사용 시 대체)
            size: 100,
            color: Colors.white,
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icon/logo_icon.png', // 로고 이미지 경로 설정
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '로그인해서 시작하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '추억의 그림일기 SNS drawee를 이용하시려면 로그인이 필요합니다.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 구글 로그인 구현
                  },
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
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 애플 로그인 구현
                  },
                  icon: const Icon(
                    Icons.apple,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: const Text(
                    '애플 로그인',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
