import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/presentation/ui/layout/main_layout.dart';
import 'package:drawee/presentation/ui/login/login_page.dart';
import 'package:drawee/presentation/ui/register/register_page.dart';
import 'package:drawee/presentation/viewmodels/auth_view_model.dart';
import 'package:drawee/presentation/viewmodels/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    Timer(const Duration(seconds: 2), () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final currentUser = FirebaseAuth.instance.currentUser;
        final userViewModel = ref.watch(userViewModelProvider.notifier);
        final userState = ref.watch(userViewModelProvider);
        if (currentUser == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          await userViewModel.getUser(currentUser.uid);

          userState.when(
            data: (data) {
              if (data.user == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLayout()),
                );
              }
            },
            error: (error, stackTrace) {
              print(error);
            },
            loading: () {
              print("loading");
            },
          );
        }
      });
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
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/splash_logo.svg'),
            ],
          ),
        ),
      ),
    );
  }
}
