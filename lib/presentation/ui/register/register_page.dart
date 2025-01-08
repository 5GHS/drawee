import 'package:drawee/domain/usecases/save_user_usecase.dart';
import 'package:drawee/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  final User? user;
  final SaveUserUseCase saveUserUseCase;

  const RegisterPage({
    super.key,
    this.user,
    required this.saveUserUseCase, // UseCase 주입
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? _profileImage;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null && widget.user!.photoURL != null) {
      _profileImage = widget.user!.photoURL; // 구글 로그인 프로필 이미지
    }
  }

  // 이미지 선택 함수
  Future<void> _selectProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile.path;
      });
    }
  }

  // 회원가입 완료 함수
  Future<void> _completeRegistration() async {
    String name = _nameController.text.trim();

    if (name.isNotEmpty) {
      try {
        // AppUser 엔티티 생성
        final appUser = AppUser(
          id: widget.user!.uid,
          name: name,
          profile: _profileImage ?? '',
        );

        // UseCase를 통해 사용자 정보 저장
        await widget.saveUserUseCase.saveUser(appUser);

        // 성공적으로 저장 후 화면을 닫고 홈 화면으로 이동
        Navigator.pop(context); // 또는 Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // 저장 중 에러 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 중 오류가 발생했습니다: $e')),
        );
      }
    } else {
      // 이름 입력하지 않은 경우 경고 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름을 입력해주세요!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // 프로필 사진
                GestureDetector(
                  onTap: _selectProfileImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null
                        ? (_profileImage!.startsWith('http')
                            ? NetworkImage(_profileImage!)
                            : FileImage(File(_profileImage!))) as ImageProvider
                        : null,
                    child: _profileImage == null
                        ? const Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                // 이름 라벨
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '이름',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // 이름 입력란
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '앱에서 사용할 이름을 입력해주세요.',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6BCF97),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '회원가입 완료',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}