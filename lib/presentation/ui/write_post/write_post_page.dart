import 'dart:io';
import 'dart:math';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/write_post/widgets/hint_text.dart';
import 'package:drawee/presentation/ui/write_post/widgets/section_title.dart';
import 'package:drawee/presentation/ui/write_post/widgets/weather_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class WritePostPage extends StatefulWidget {
  const WritePostPage({super.key});

  @override
  State<WritePostPage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePostPage> {
  File? _image; // 이미지 저장할 변수
  Uint8List? _editedImage; // 편집된 이미지 저장할 변수

  final ImagePicker _picker = ImagePicker(); // 이미지 피커 인스턴스

  // 이미지 선택하고 ProImageEditor로 편집도 수행
  Future<void> _pickAndEditImage(ImageSource source) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: source); // 갤러리에서 선택 또는 사진 찍기 모두 지원하도록
    if (pickedFile == null) return; // 이미지 선택하지 않으면 종료
    final originalImage = File(pickedFile.path); // 선택된 이미지 파일
    final File? editedImage = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (context) => ProImageEditor.file(
          originalImage,
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              final tempDir = Directory.systemTemp;
              final editedFile =
                  File('${tempDir.path}/${Random().nextInt(10000)}.png');
              await editedFile.writeAsBytes(bytes);
              Navigator.pop(context, editedFile);
              // return editedFile;
            },
          ),
        ),
      ),
    );
    setState(() {
      _image = editedImage ?? originalImage;
    });
  }

  // 갤러리 또는 카메라
  Future<void> _showImageSourceActionSheet() async {
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
                    _pickAndEditImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('카메라로 촬영'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndEditImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        });
  }

// /data/user/0/com.oghs.drawee/code_cache/line_art.png
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(title: Text('새 그림 일기')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                SectionTitle(text: '주제'),
                SizedBox(height: 16),
                Container(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "글과 관련된 주제를 선택해 주세요",
                      hintStyle: TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      filled: true,
                      fillColor: AppColors.lightGray,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lightGray),
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 19),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        color: AppColors.darkGray,
                        onPressed: () {
                          // TODO: 주제 검색 기능
                          print('주제 검색!');
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.lightGray,
                            width: 1.0), // 비활성 상태 테두리
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.green, width: 1.0), // 활성 상태 테두리
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SectionTitle(text: '날씨'),
                SizedBox(height: 16),
                Container(
                  height: 52,
                  child: Row(
                    children: [
                      weatherButton(
                        weather: 'sunny',
                      ),
                      SizedBox(width: 14),
                      weatherButton(
                        weather: 'rainy',
                      ),
                      SizedBox(width: 14),
                      weatherButton(
                        weather: 'cloudy',
                      ),
                      SizedBox(width: 14),
                      weatherButton(
                        weather: 'windy',
                      ),
                      SizedBox(width: 14),
                      weatherButton(
                        weather: 'snowy',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SectionTitle(text: '그림'),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _showImageSourceActionSheet,
                  child: Container(
                    height: 362,
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
                                    height: 36),
                                Text(
                                  '그린 그림 사진을 올려주시면',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                                Text(
                                  '저희가 깔끔한 라인아트로 변경해 드려요!',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                              ]))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(_image!, fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(height: 16),
                Container(child: SectionTitle(text: '일기 제목')),
                SizedBox(height: 16),
                Container(
                  height: 42,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      hintText: "일기 제목을 적어주세요",
                      hintStyle: hintTextStyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SectionTitle(text: '일기 내용'),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      hintText: "일기 내용을 적어주세요",
                      hintStyle: hintTextStyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(20))),
                  maxLines: 10,
                ),
                SizedBox(height: 30),

                // 일기 업로드 버튼
                // TODO: 일기 업로드 버튼 클릭 시 일기 업로드 기능 구현
                Container(
                  height: 54,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "일기 업로드",
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }
}
