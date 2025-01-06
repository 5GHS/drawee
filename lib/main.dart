import 'package:flutter/material.dart';
import 'package:drawee/presentation/pags/splash/splash_pags.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'drawee',
      theme: ThemeData.dark(),
      home: const SplashPage(),
    );
  }
}
