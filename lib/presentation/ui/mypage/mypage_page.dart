import 'dart:io';

import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/mypage/liked_posts_page.dart';
import 'package:drawee/presentation/ui/mypage/written_posts_page.dart';
import 'package:drawee/presentation/ui/splash/splash_page.dart';
import 'package:drawee/presentation/viewmodels/auth_view_model.dart';
import 'package:drawee/presentation/viewmodels/user_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

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
          // userState.user?.writtenPostsIds
          final writtenPostsIds = userState.user?.writtenPostsIds ?? [];
          final likedPostsIds = userState.user?.likedPostsIds ?? [];
          print('writtenPostsIds: $writtenPostsIds');
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
                      "쓴 글 ${userState.user?.writtenPostsIds.length}회",
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.darkGray),
                    ),
                    // trailing: SvgPicture.asset('assets/icon/profile_edit.svg'),
                    trailing: GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: Text('로그아웃 하시겠습니까?'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text('취소'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text('로그아웃'),
                                  onPressed: () {
                                    ref
                                        .read(authViewModelProvider.notifier)
                                        .signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SplashPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Icons.logout),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icon/written.svg'),
                              SizedBox(width: 8),
                              Text('내가 쓴 글', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WrittenPostsPage(postIds: writtenPostsIds),
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            alignment: Alignment.centerRight,
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.black,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icon/stamp_bold.svg'),
                              SizedBox(width: 8),
                              Text('참 잘했어요 누른 글',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('tap');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LikedPostsPage(postIds: likedPostsIds),
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            alignment: Alignment.centerRight,
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.black,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     ref.read(authViewModelProvider.notifier).signOut();
                //   },
                //   child: const Text('로그아웃'),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     ref
                //         .read(userViewModelProvider.notifier)
                //         .deleteUser(userState.user?.id ?? '');
                //   },
                //   child: const Text('회원탈퇴'),
                // ),
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
