import 'dart:async';

import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/presentation/providers/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final AppUser? user;

  const UserState({required this.user});
}

class UserViewModel extends AsyncNotifier<UserState> {
  @override
  FutureOr<UserState> build() {
    return const UserState(user: null);
  }

  Future<void> getUser(String uid) async {
    final user = await ref.read(getUserUseCaseProvider).execute(uid);
    state = AsyncValue.data(UserState(user: user));
  }

  Future<void> createUser(AppUser user) async {
    await ref.read(createUserUseCaseProvider).execute(user);
    state = AsyncValue.data(UserState(user: user));
  }

  Future<void> updateUser(String uid, String imgUrl) async {
    final user = await ref.read(getUserUseCaseProvider).execute(uid);
    if (user != null) {
      final updatedUser = user.copyWith(imgUrl: imgUrl);
      await ref.read(updateUserUseCaseProvider).execute(updatedUser);
      state = AsyncValue.data(UserState(user: updatedUser));
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> deleteUser(String uid) async {
    await ref.read(deleteUserUseCaseProvider).execute(uid);
  }
}

final userViewModelProvider = AsyncNotifierProvider<UserViewModel, UserState>(
  () => UserViewModel(),
);
