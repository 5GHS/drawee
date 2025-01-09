import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
}
