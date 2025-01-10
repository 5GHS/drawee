import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/viewmodels/auth_view_model.dart';
import 'package:drawee/presentation/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MypagePage extends ConsumerWidget {
  const MypagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: userState.when(
        data: (userState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.lightGray)),
                  child: ListTile(
                    leading: const CircleAvatar(), // TODO: user Img 삽입 필요
                    title: Text(
                      userState.user?.name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    subtitle: Text(
                      "쓴 글 ${userState.user?.likedPostsIds.length}회",
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.darkGray),
                    ),
                    trailing: SvgPicture.asset('assets/icon/profile_edit.svg'),
                  ),
                ),
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
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
