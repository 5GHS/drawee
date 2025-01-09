import 'dart:io';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/write_post/widgets/hint_text.dart';
import 'package:drawee/presentation/ui/write_post/widgets/section_title.dart';
import 'package:drawee/presentation/ui/write_post/widgets/weather_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class WritePostPage extends StatefulWidget {
  const WritePostPage({super.key});

  @override
  State<WritePostPage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePostPage> {
  File? _image; // 이미지 저장할 변수 - 원본 이미지
  File? _lineArtImage; // 라인아트 이미지
  final ImagePicker _picker = ImagePicker(); // 이미지 피커 인스턴스

  // Sobel Edge Detection 함수
  Future<File> _convertToLineArt(File originalImage) async {
    final bytes = await originalImage.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('이미지를 불러올 수 없습니다');
    }

    //final img.Image grayscale = img.grayscale(image); // 그레이스케일
    final img.Image sobel = img.sobel(image); // 소벨 필터 적용
    final img.Image inverted = img.invert(sobel); // 흰색과 검은색 반전
    //final img.Image blurred = img.gaussianBlur(inverted, radius: 2); // 블러 처리는 의미가 별로 없구만

    final tempDir = Directory.systemTemp;
    final File output = File('${tempDir.path}/line_art.png');
    print('라인아트 이미지 경로: ${output.path}');
    await output.writeAsBytes(img.encodePng(sobel));
    return output;
  }

  // 이미지 선택 함수에 라인아트 기능 더하기
  Future<void> _pickAndProcessImage(ImageSource source) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: source); // 갤러리에서 선택 또는 사진 찍기 모두 지원하도록
    if (pickedFile != null) {
      final originalImage = File(pickedFile.path);
      final lineArtImage = await _convertToLineArt(originalImage);

      setState(() {
        _image = originalImage; // 선택된 이미지 파일 상태 변수에 저장
        _lineArtImage = lineArtImage; // 라인아트 이미지 파일 상태 변수에 저장
      });
    }
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
                    _pickAndProcessImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('카메라로 촬영'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndProcessImage(ImageSource.camera);
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
                            child:
                                Image.file(_lineArtImage!, fit: BoxFit.cover)),
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
