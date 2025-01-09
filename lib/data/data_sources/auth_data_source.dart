import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<User?> signInWithGoogle(); // 로그인 후 유저 아이디 반환
  Future<void> signOut();
}
