import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/domain/entities/subject.dart';
import 'package:drawee/presentation/ui/layout/main_layout.dart';
import 'package:drawee/presentation/ui/subject_post/widgets/search_bar_widget.dart';
import 'package:drawee/presentation/ui/subject_search/write_subject_search_page.dart';
import 'package:drawee/presentation/ui/write_post/widgets/hint_text.dart';
import 'package:drawee/presentation/ui/write_post/widgets/section_title.dart';
import 'package:drawee/presentation/ui/write_post/widgets/weather_button.dart';
import 'package:drawee/presentation/ui/write_post/write_post_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../../../domain/entities/post.dart';

class WritePostPage extends ConsumerStatefulWidget {
  const WritePostPage({super.key});

  @override
  ConsumerState<WritePostPage> createState() => _WritePageState();
}

enum Weather {
  sunny,
  rainy,
  cloudy,
  windy,
  snowy,
}

class _WritePageState extends ConsumerState<WritePostPage> {
  File? _image; // 이미지 저장할 변수
  final ImagePicker _picker = ImagePicker(); // 이미지 피커 인스턴스

  Subject? _subject;
  final _titleController = TextEditingController(); // 제목 입력 컨트롤러
  final _contentController = TextEditingController(); // 내용 입력 컨트롤러

  Weather? _selectedWeather; // 선택된 날씨

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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
                  leading: const Icon(Icons.photo),
                  title: const Text('갤러리에서 선택'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndEditImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('카메라로 촬영'),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(writePostViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text(
            '새 그림 일기',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const SectionTitle(text: '주제'),
                  const SizedBox(height: 16),
                  _subject != null
                      ? GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WriteSubjectSearchPage(),
                                ));
                            // 결과가 있을 경우 topic과 posts 업데이트
                            if (result != null) {
                              print('result: ${result.subjectId}');
                              setState(() {
                                _subject = result;
                              });
                            }
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          73, 247, 247, 247), // 대략 50%
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              75, 13, 187, 132)), // 대략 25%
                                    ),
                                    child: Text(
                                      "#${_subject?.topic}",
                                      style: const TextStyle(
                                        color: AppColors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        )
                      : Container(
                          height: 40,
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const WriteSubjectSearchPage(),
                                  ));
                              // 결과가 있을 경우 topic과 posts 업데이트
                              if (result != null) {
                                print('result: ${result.subjectId}');
                                setState(() {
                                  _subject = result;
                                });
                              }
                            },
                            child: const SearchBarWidget(),
                          ),
                        ),
                  const SizedBox(height: 16),
                  const SectionTitle(text: '날씨'),
                  const SizedBox(height: 16),
                  // 날씨 선택 버튼
                  Container(
                    height: 52,
                    child: Row(
                      children: [
                        for (final weather in Weather.values) ...[
                          if (weather != Weather.sunny)
                            const SizedBox(width: 14),
                          weatherButton(
                            weather: weather.name,
                            isSelected: _selectedWeather == weather,
                            onTap: () {
                              setState(() {
                                _selectedWeather = weather;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionTitle(text: '그림'),
                  const SizedBox(height: 16),
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
                                  const Text(
                                    '그린 그림 사진을 올리실때',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                                  const Text(
                                    '마음껏 편집하실 수 있습니다.',
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
                  const SizedBox(height: 16),
                  // 일기 제목
                  const SectionTitle(text: '일기 제목'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 42,
                    child: TextFormField(
                      controller: _titleController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '제목을 입력해주세요';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        hintText: "일기 제목을 적어주세요",
                        hintStyle: hintTextStyle,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.gray, width: 1.0), // 비활성 상태 테두리
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.green, width: 1.0), // 활성 상태 테두리
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // 에러 상태일 때의 테두리 스타일
                        errorBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.onError, width: 1.0),
                        ),
                        // 에러 상태에서 포커스될 때의 테두리 스타일
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.onError, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 일기 내용
                  const SectionTitle(text: '일기 내용'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 167,
                    child: TextFormField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      textInputAction: TextInputAction.newline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '내용을 입력해주세요';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        hintText: "일기 내용을 적어주세요",
                        hintStyle: hintTextStyle,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.gray, width: 1.0), // 비활성 상태 테두리
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.green, width: 1.0), // 활성 상태 테두리
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 일기 업로드 버튼
                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          final titleValue = _titleController.text.trim();
                          final contentValue = _contentController.text.trim();
                          final weatherValue = _selectedWeather?.name ?? '';

                          if (weatherValue.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('날씨를 선택해주세요.'),
                                backgroundColor: AppColors.onError,
                              ),
                            );
                            return;
                          }

                          final userId = FirebaseAuth.instance.currentUser?.uid;

                          final newPost = Post(
                            postId: '',
                            comments: [],
                            content: contentValue,
                            userId: userId ?? '',
                            title: titleValue,
                            imageUrl:
                                '', // This will be updated after image upload
                            subjectId: _subject?.subjectId ?? '',
                            weather: weatherValue,
                            likes: 0,
                            createdAt: DateTime.now(),
                          );

                          final success = await viewModel.createPost(newPost,
                              image: _image);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('일기가 성공적으로 업로드되었습니다.'),
                                backgroundColor: AppColors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MainLayout(initialIndex: 1),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '일기 업로드에 실패했습니다: ${viewModel.errorMessage.value}'),
                                backgroundColor: AppColors.onError,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: viewModel.isLoading,
                        builder: (context, isLoading, child) {
                          return isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : const Text(
                                  "일기 업로드",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
