import 'dart:io';
import 'dart:developer' as developer;
import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/usecases/post/create_post_usecase.dart';
import 'package:drawee/domain/usecases/post/delete_post_usecase.dart';
import 'package:drawee/domain/usecases/post/get_post_usecase.dart';
import 'package:drawee/domain/usecases/post/update_post_usecase.dart';
import 'package:drawee/domain/usecases/post/yolo_detection_usecase.dart';
import 'package:drawee/presentation/providers/post_providers.dart';
import 'package:drawee/presentation/viewmodels/post_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

class WritePostViewModel {
  final PostViewModel _postViewModel;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> imageUrl = ValueNotifier<String?>(null);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);
  final yoloDetectionUseCase _yoloDetectionUseCase;

  WritePostViewModel(this._postViewModel, this._yoloDetectionUseCase);

  Future<bool> createPost(Post post, {File? image}) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // 이미지가 있는 경우 먼저 업로드
      if (image != null) {
        final uploadedUrl = await uploadImage(XFile(image.path));
        post = post.copyWith(imageUrl: uploadedUrl);
      }

      await _postViewModel.createPost(post);

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = '포스트 저장 실패: $e';
      return false;
    }
  }

  Future<bool> updatePost(Post post, {File? image}) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // 이미지가 있는 경우 먼저 업로드
      if (image != null) {
        final uploadedUrl = await uploadImage(XFile(image.path));
        post = post.copyWith(imageUrl: uploadedUrl);
      }

      await _postViewModel.updatePost(post);

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = '포스트 수정 실패: $e';
      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await _postViewModel.deletePost(postId);

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = '삭제 실패: $e';
      return false;
    }
  }

  Future<String> uploadImage(XFile image) async {
    try {
      final storage = FirebaseStorage.instance;
      Reference ref = storage.ref();
      Reference fileRef =
          ref.child('${DateTime.now().millisecondsSinceEpoch}_${image.name}');
      await fileRef.putFile(File(image.path));
      String postImageUrl = await fileRef.getDownloadURL();
      imageUrl.value = postImageUrl;
      return postImageUrl;
    } catch (e) {
      errorMessage.value = '사진 업로드 실패: $e';
      throw Exception('사진 업로드 실패: $e');
    }
  }

  Future<bool> checkHuman(File image) async {
    if (!_yoloDetectionUseCase.isInit) {
      await _yoloDetectionUseCase.init();
    }

    final img = decodeImage(image.readAsBytesSync());
    if (img == null) {
      developer.log('Failed to decode image', name: 'YOLO Detection');
      return false;
    }
    final detectedObjects = _yoloDetectionUseCase.runInference(img!);
    final containsPerson = detectedObjects
        .any((obj) => _yoloDetectionUseCase.label(obj.labelIndex) == 'person');

    developer.log(
        'Detected objects: ${detectedObjects.map((obj) => _yoloDetectionUseCase.label(obj.labelIndex)).join(', ')}',
        name: 'YOLO Detection');
    developer.log('Contains person: $containsPerson', name: 'YOLO Detection');

    return containsPerson;
  }
}

final writePostViewModelProvider = Provider<WritePostViewModel>((ref) {
  return WritePostViewModel(
    ref.watch(postViewModelProvider.notifier),
    ref.watch(yoloDetectionUseCaseProvider),
  );
});
