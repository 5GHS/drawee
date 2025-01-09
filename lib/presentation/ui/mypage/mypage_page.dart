import 'package:drawee/presentation/viewmodels/auth_view_model.dart';
import 'package:drawee/presentation/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MypagePage extends ConsumerWidget {
  const MypagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      body: Center(
        child: userState.when(
          data: (userState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(userState.user?.id ?? ''),
                Text(userState.user?.name ?? ''),
                Text(userState.user?.imgUrl ?? ''),
                Text(userState.user?.likedPostsIds.toString() ?? ''),
                Text(userState.user?.writtenPostsIds.toString() ?? ''),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authViewModelProvider.notifier).signOut();
                  },
                  child: const Text('로그아웃'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(userViewModelProvider.notifier)
                        .deleteUser(userState.user?.id ?? '');
                  },
                  child: const Text('회원탈퇴'),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
