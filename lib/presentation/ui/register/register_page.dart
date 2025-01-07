import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // image_picker import

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _profileImage;

  // 프로필 사진을 선택하는 함수
  void _selectProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택

    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile.path; // 선택된 이미지 경로 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: const Color(0xFF6BCF97),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 사진
            GestureDetector(
              onTap: _selectProfileImage, // 이미지 선택
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!)) // 파일에서 이미지를 표시
                    : null,
                child: _profileImage == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            // 제목: 이름
            const Text(
              '이름',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // 이름 입력란
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름을 입력하세요',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            // 회원가입 완료 버튼 (화면 하단에 고정)
            Spacer(),  // 남은 공간을 채우는 Spacer 위젯 추가
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 이름 입력 처리
                  String name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    // 회원가입 처리 후 다음 페이지로 넘어가거나 알림을 표시하는 코드
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('회원가입 완료: $name')),
                    );
                  } else {
                    // 이름이 비어있는 경우
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이름을 입력해주세요.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6BCF97), // 배경색
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
          ],
        ),
      ),
    );
  }
}