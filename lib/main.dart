import 'package:drawee/add_mock_data.dart';
import 'package:drawee/domain/usecases/post/yolo_detection_usecase.dart';
import 'package:drawee/presentation/ui/home/home_page.dart';
import 'package:drawee/presentation/ui/subject_search/subject_search_page.dart';
import 'package:drawee/presentation/ui/splash/splash_page.dart';
import 'package:drawee/presentation/ui/weather_post/weather_post_page.dart';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/layout/main_layout.dart';
import 'package:drawee/core/utils/firestore_utils.dart';
import 'package:drawee/presentation/ui/splash/splash_page.dart';
import 'package:drawee/presentation/ui/write_post/write_post_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drawee/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // * 데이터 추가할때 사용하세요
  // await getFirestoreDocument(
  //   collectionPath: 'users',
  //   documentId: 'FszUedGevd7iynzSDcep',
  // );
  await yoloDetectionUseCase().init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'drawee',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          elevation: 0,
        ),
      ),
      //home: const SplashPage(),
      home: const WritePostPage(),
    );
  }
}
