import 'dart:io';
import 'package:drawee/domain/entities/post.dart';
import 'package:drawee/domain/repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _repository;
  //final ImageUploader _imageUploader;

  CreatePostUseCase(this._repository);

  Future<bool> execute(Post post, {File? image}) async {
    // 이미지가 없는 경우 기본 빈 문자열 사용
    String imageUrl = '';

    // if (image != null) {
    //   imageUrl = await _imageUploader.uploadImage(image);
    // }

    // 저장소를 통해 포스트 생성
    return _repository.createPost(post);
  }
}
