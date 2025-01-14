import 'dart:io';

import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/viewmodels/auth_view_model.dart';
import 'package:drawee/presentation/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider = StateProvider<File?>((ref) {
  return null;
});

class MypagePage extends ConsumerWidget {
  MypagePage({super.key});

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: source); // 갤러리에서 선택 또는 사진 찍기 모두 지원하도록
    if (pickedFile == null) return; // 이미지 선택하지 않으면 종료
    final originalImage = File(pickedFile.path); // 선택된 이미지 파일
    ref.read(imageProvider.notifier).update((state) => originalImage);
  }

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
                    leading: GestureDetector(
                      onTap: () => _pickImage(ref, ImageSource.gallery),
                      child: CircleAvatar(
                        backgroundImage: ref.watch(imageProvider) != null
                            ? FileImage(ref.watch(imageProvider)!)
                            : null,
                        child: ref.watch(imageProvider) == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                    ),
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
