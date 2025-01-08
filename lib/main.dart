import 'package:drawee/add_mock_data.dart';
import 'package:drawee/presentation/ui/home/home_page.dart';
import 'package:drawee/presentation/ui/search/search_page.dart';
import 'package:drawee/presentation/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drawee/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'drawee',
      home: AddMockData(),
    );
    // return MaterialApp(
    //   title: 'drawee',
    //   home: SearchPage(),
    // );
  }
}
