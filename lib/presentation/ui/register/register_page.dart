import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/domain/entities/user.dart';
import 'package:drawee/presentation/ui/layout/main_layout.dart';
import 'package:drawee/presentation/viewmodels/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends ConsumerState<RegisterPage> {
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userState = ref.watch(userViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userState.when(
        data: (userState) {
          if (userState.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainLayout()),
            );
          }
        },
        loading: () => null,
        error: (error, stack) => {print(error)},
      );
    });
    bool isFormValid = nameController.text.isNotEmpty;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
          "회원가입",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                widthFactor: double.infinity,
                heightFactor: 2,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.lightGray,
                      width: 1.0,
                    ),
                  ),
                  child: currentUser?.photoURL != null
                      ? ClipOval(
                          child: Image.network(
                            currentUser?.photoURL ?? '',
                          ),
                        )
                      : Icon(Icons.person),
                ),
              ),
              const Text("이름",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {
                      isFormValid = nameController.text.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: '앱에서 사용할 이름을 입력해주세요',
                    hintStyle: const TextStyle(color: AppColors.darkGray),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.lightGray,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.lightGray,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 34),
              SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: isFormValid
                        ? () async {
                            final userViewModel =
                                ref.read(userViewModelProvider.notifier);

                            if (currentUser != null) {
                              final newUser = AppUser(
                                id: currentUser.uid,
                                imgUrl: currentUser.photoURL ?? '',
                                likedPostsIds: [],
                                name: nameController.text,
                                writtenPostsIds: [],
                              );

                              await userViewModel.createUser(newUser);
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFormValid ? AppColors.green : AppColors.lightGray,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "회원가입 하기",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
