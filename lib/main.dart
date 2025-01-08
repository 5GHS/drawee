import 'package:drawee/add_mock_data.dart';
import 'package:drawee/presentation/ui/home/home_page.dart';
import 'package:drawee/presentation/ui/search/search_page.dart';
import 'package:drawee/presentation/ui/splash/splash_page.dart';
import 'package:drawee/presentation/ui/weather_post/weather_post_page.dart';
import 'package:drawee/core/utils/firestore_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drawee/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await getFirestoreDocument(
    collectionPath: 'posts',
    documentId: '0MYZlzCIzmmyZvJfhmLi',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'drawee',
      home: WeatherPostPage(),
    );
    // return MaterialApp(
    //   title: 'drawee',
    //   home: SearchPage(),
    // );
  }
}
