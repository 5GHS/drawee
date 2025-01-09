import 'package:drawee/data/repositories/user_repository.dart';
import 'package:drawee/domain/repositories/user_repository.dart';
import 'package:drawee/domain/usecases/save_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:drawee/presentation/ui/register/register_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider 설정
final appUserRepositoryProvider = Provider<AppUserRepository>((ref) {
  return AppUserRepositoryImpl(); // 실제 구현체 반환
});

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  // 구글 로그인 함수
  Future<User?> signInWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null; // 로그인 취소 시 null 반환
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // 로그인 성공 시 RegisterPage로 이동
      if (userCredential.user != null) {
        final appUserRepository = ref.read(appUserRepositoryProvider); // Provider에서 구현체 접근
        final saveUserUseCase = SaveUserUseCase(appUserRepository);

        print("User logged in: ${userCredential.user!.email}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(saveUserUseCase: saveUserUseCase),
          ),
        );
      }

      return userCredential.user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해주세요.')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF6BCF97), // 배경색 설정
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Icon(
            Icons.tag, // 상단 로고나 아이콘
            size: 120, // 크기 키움
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
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6BCF97), // 녹색 배경
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'd', // 아이콘 내부 텍스트
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // 흰색 텍스트
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                // 구글 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      signInWithGoogle(context, ref); // 로그인 후 페이지 이동
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
                ),
                const SizedBox(height: 8),
                // 애플 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}