import 'package:flutter/material.dart';
import 'package:drawee/presentation/ui/login/login_page.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    // 애니메이션 설정
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // 임시 5초 후 로그인 페이지로 이동
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 흰색 배경
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고 이미지
              Image.asset(
                'assets/icon/logo_icon.png',
                width: 53,
                height: 53,
              ),
              const SizedBox(width: 12), // 로고와 텍스트 사이 간격
              // 앱 이름
              const Text(
                'drawee',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 107, 207, 151), // 녹색 텍스트 색상
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
