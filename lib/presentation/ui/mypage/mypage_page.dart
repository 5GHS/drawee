import 'dart:io';

import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/viewmodels/auth_view_model.dart';
import 'package:drawee/presentation/viewmodels/user_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

final imageProvider = StateProvider<File?>((ref) {
  return null;
});

class MypagePage extends ConsumerWidget {
  MypagePage({super.key});

  final ImagePicker _picker = ImagePicker();
  final _nameController = TextEditingController();

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    final originalImage = File(pickedFile.path);
    ref.read(imageProvider.notifier).update((state) => originalImage);

    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef
        .child('${DateTime.now().millisecondsSinceEpoch}_profile.png');
    await fileRef.putFile(originalImage);
    final downloadUrl = await fileRef.getDownloadURL();

    final userState = ref.watch(userViewModelProvider);

    userState.whenData((userState) {
      ref.read(userViewModelProvider.notifier).updateUser(
            userState.user?.id ?? '',
            imgUrl: downloadUrl,
          );
    });
  }

  Future<void> _loadImagePath(WidgetRef ref) async {
    final directory = await getApplicationDocumentsDirectory();
    final File imagePath = File('${directory.path}/picked_image.jpg');

    if (imagePath.existsSync()) {
      ref.read(imageProvider.notifier).update((state) => imagePath);
      ref.read(imageProvider.notifier).state = imagePath;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _loadImagePath(ref);

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
                      border: Border.all(color: AppColors.gray)),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => _pickImage(ref, ImageSource.gallery),
                      child: CircleAvatar(
                        backgroundImage: userState.user?.imgUrl != null
                            ? NetworkImage(userState.user?.imgUrl ?? '')
                            : null,
                        child: userState.user?.imgUrl == null &&
                                ref.watch(imageProvider) == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                    ),
                    title: Text(
                      userState.user?.name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    subtitle: Text(
                      "쓴 글 ${userState.user?.likedPostsIds.length}회",
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.darkGray),
                    ),
                    trailing: SvgPicture.asset('assets/icon/profile_edit.svg'),
                  ),
                ),
                SizedBox(height: 20),
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
