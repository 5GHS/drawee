import 'dart:io';
import 'dart:math';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/domain/usecases/post/create_post_usecase.dart';
import 'package:drawee/presentation/providers/post_providers.dart';
import 'package:drawee/presentation/providers/user_providers.dart';
import 'package:drawee/presentation/ui/layout/main_layout.dart';
import 'package:drawee/presentation/ui/weather_post/weather_post_page.dart';
import 'package:drawee/presentation/ui/write_post/widgets/diary_input_field.dart';
import 'package:drawee/presentation/ui/write_post/widgets/hint_text.dart';
import 'package:drawee/presentation/ui/write_post/widgets/section_title.dart';
import 'package:drawee/presentation/ui/write_post/widgets/weather_button.dart';
import 'package:drawee/presentation/ui/write_post/write_post_view_model.dart';
import 'package:drawee/presentation/viewmodels/auth_view_model.dart';
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

  final _subjectController = TextEditingController(); // 주제 입력 컨트롤러
  final _titleController = TextEditingController(); // 제목 입력 컨트롤러
  final _contentController = TextEditingController(); // 내용 입력 컨트롤러

  Weather? _selectedWeather; // 선택된 날씨

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectController.dispose();
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

  Future<String> _getUserName(String userId) async {
    final userRepository = ref.read(userRepositoryProvider);
    final user = await userRepository.getUser(userId);
    return user?.name ?? '알 수 없는 사용자';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(writePostViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(title: Text('새 그림 일기')),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  SectionTitle(text: '주제'),
                  SizedBox(height: 16),
                  Container(
                    height: 40,
                    child: TextFormField(
                      controller: _subjectController,
                      textInputAction: TextInputAction.go, // 검색이라서
                      // validator: (value) {
                      //   if (value == null || value.trim().isEmpty) {
                      //     return '주제를 입력해주세요';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        hintText: "글과 관련된 주제를 선택해 주세요",
                        hintStyle: TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: AppColors.lightGray,

                        contentPadding: EdgeInsets.symmetric(horizontal: 19),
                        // TODO: 주제 검색 기능 추가
                        // suffixIcon: IconButton(
                        //   icon: Icon(Icons.search),
                        //   color: AppColors.darkGray,
                        //   onPressed: () {
                        //     print('주제 검색!');
                        //   },
                        // ),
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
                  // 일기 제목
                  Container(child: SectionTitle(text: '일기 제목')),
                  SizedBox(height: 16),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        hintText: "일기 제목을 적어주세요",
                        hintStyle: hintTextStyle,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.gray, width: 1.0), // 비활성 상태 테두리
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.green, width: 1.0), // 활성 상태 테두리
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // 에러 상태일 때의 테두리 스타일
                        errorBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.onError, width: 1.0),
                        ),
                        // 에러 상태에서 포커스될 때의 테두리 스타일
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.onError, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // 일기 내용
                  SectionTitle(text: '일기 내용'),
                  SizedBox(height: 16),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        hintText: "일기 내용을 적어주세요",
                        hintStyle: hintTextStyle,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.gray, width: 1.0), // 비활성 상태 테두리
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
                  SizedBox(height: 30),

                  // 일기 업로드 버튼
                  Container(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          final subjectValue = _subjectController.text.trim();
                          final titleValue = _titleController.text.trim();
                          final contentValue = _contentController.text.trim();
                          final weatherValue = _selectedWeather?.name ?? '';

                          if (weatherValue.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('날씨를 선택해주세요.'),
                                backgroundColor: AppColors.onError,
                              ),
                            );
                            return;
                          }

                          final userId = authState.when(
                            data: (auth) => auth.user?.uid ?? '알 수 없는 사용자',
                            error: (_, __) => 'user data error',
                            loading: () => '사용자 데이터 로딩 중...',
                          );

                          final userName = await _getUserName(userId);

                          final newPost = Post(
                            postId: '', // Firebase will generate this
                            comments: [],
                            content: contentValue,
                            userId: userId,
                            title: titleValue,
                            imageUrl:
                                '', // This will be updated after image upload
                            subjectId: subjectValue,
                            weather: weatherValue,
                            likes: 0,
                            createdAt: DateTime.now(),
                          );

                          final success = await viewModel.createPost(newPost,
                              image: _image);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('일기가 성공적으로 업로드되었습니다.'),
                                backgroundColor: AppColors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MainLayout(initialIndex: 1),
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
                      child: ValueListenableBuilder<bool>(
                        valueListenable: viewModel.isLoading,
                        builder: (context, isLoading, child) {
                          return isLoading
                              ? CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : Text(
                                  "일기 업로드",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                        },
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
          ),
        ),
      ),
    );
  }
}
