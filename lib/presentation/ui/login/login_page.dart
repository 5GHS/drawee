import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/layout/main_layout.dart';
import 'package:drawee/presentation/ui/login/widgets/privacy_policy.dart';
import 'package:drawee/presentation/ui/register/register_page.dart';
import 'package:drawee/presentation/viewmodels/auth_view_model.dart';
import 'package:drawee/presentation/viewmodels/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final userViewModel = ref.read(userViewModelProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return;
      }

      try {
        await userViewModel.getUser(currentUser.uid);
        final userState = ref.read(userViewModelProvider);

        userState.when(
          data: (userState) {
            if (userState.user == null) {
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
          error: (error, stack) {
            print(error);
          },
          loading: () {
            print("로딩중...");
          },
        );
      } catch (e) {
        print(e);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset('assets/images/login_page_logo.svg'),
          const Spacer(),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
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
                    onPressed: () async {
                      await authViewModel.signInGoogle();
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        await userViewModel.getUser(currentUser.uid);
                        final userState = ref.read(userViewModelProvider);
                        userState.when(
                          data: (data) {
                            if (data.user == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainLayout()),
                              );
                            }
                          },
                          error: (error, stackTrace) {
                            print(error);
                          },
                          loading: () => print("로딩중..."),
                        );
                      }
                    },
                    icon: Image.asset(
                      'assets/icon/google_icon.png',
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
                // 개인정보 처리방침
                const PrivacyPolicy(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
