import 'dart:async';

import 'package:drawee/presentation/providers/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final User? user;

  const AuthState({required this.user});
}

class AuthViewModel extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() {
    return const AuthState(user: null);
  }

  Future<void> signInGoogle() async {
    final user = await ref.read(signInGoogleUsecaseProvider).execute();
    state = AsyncValue.data(AuthState(user: user));
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = const AsyncValue.data(AuthState(user: null));
  }
}

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
