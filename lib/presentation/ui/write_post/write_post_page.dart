import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WritePostPage extends StatefulWidget {
  const WritePostPage({super.key});

  @override
  State<WritePostPage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePostPage> {
  File? _image; // 이미지 저장할 변수
  final ImagePicker _picker = ImagePicker(); // 이미지 피커 인스턴스

  // 이미지 선택 함수
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: source); // 갤러리에서 선택 또는 사진 찍기 모두 지원하도록
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // 선택된 이미지 파일 상태 변수에 저장
      });
    }
  }

  // 갤러리 또는 카메라
  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('갤러리에서 선택'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('카메라로 촬영'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('새 그림 일기')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('주제'),
                // TODO: 주제 선택 모듈
                TextField(
                  decoration: InputDecoration(
                      hintText: "글과 관련된 주제를 선택해 주세요",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(height: 10),
                Text('마음 날씨'),
                // TODO: 마음날씨 선택 모듈
                SizedBox(height: 10),
                Text('그림'),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    height: 360,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _image == null
                        ? Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Image.asset('assets/icon/writePostIcon.png',
                                    height: 50),
                                Text('그린 그림 사진을 올려주시면'),
                                Text('저희가 깔끔한 라인아트로 변경해 드려요!'),
                              ]))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(_image!, fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(height: 10),
                Text('일기 제목'),
                TextField(
                  decoration: InputDecoration(
                    hintText: "일기 제목을 적어주세요",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 10),
                Text('일기 내용'),
                TextField(
                  decoration: InputDecoration(
                      hintText: "일기 내용을 적어주세요",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  maxLines: 10,
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: () {}, child: Text("일기 업로드")),
                SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }
}
