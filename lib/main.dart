import 'package:drawee/presentation/ui/home/home_page.dart';
import 'package:drawee/presentation/ui/login/login_page.dart';
import 'package:drawee/presentation/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'drawee',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(), // 스플래쉬 화면을 먼저 보여줌
        '/login': (context) => const LoginPage(), // 로그인 화면
        '/home': (context) => HomePage(), // 홈 화면
      },
    );
  }
}