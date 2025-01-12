import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawee/domain/usecases/post/yolo_detection_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drawee/data/data_sources/firebase_post_data_source.dart';
import 'package:drawee/data/data_sources/post_data_source.dart';
import 'package:drawee/data/repositories/post_repository_impl.dart';
import 'package:drawee/domain/repositories/post_repository.dart';
import 'package:drawee/domain/usecases/post/get_post_usecase.dart';
import 'package:drawee/domain/usecases/post/get_posts_usecase.dart';
import 'package:drawee/domain/usecases/post/get_posts_by_weather_usecase.dart';
import 'package:drawee/domain/usecases/post/create_post_usecase.dart';
import 'package:drawee/domain/usecases/post/update_post_usecase.dart';
import 'package:drawee/domain/usecases/post/delete_post_usecase.dart';
import 'package:drawee/domain/usecases/post/get_posts_by_subject_id_usecase.dart';
import 'package:drawee/domain/usecases/post/get_posts_by_user_id_usecase.dart';

final postDataSourceProvider = Provider<PostDataSource>((ref) {
  return FirebasePostDataSource(FirebaseFirestore.instance);
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(ref.watch(postDataSourceProvider));
});

final getPostUseCaseProvider = Provider<GetPostUseCase>((ref) {
  return GetPostUseCase(ref.watch(postRepositoryProvider));
});

final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  return GetPostsUseCase(ref.watch(postRepositoryProvider));
});

final getPostsByWeatherUseCaseProvider =
    Provider<GetPostsByWeatherUseCase>((ref) {
  return GetPostsByWeatherUseCase(ref.watch(postRepositoryProvider));
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return CreatePostUseCase(repository);
});

final updatePostUseCaseProvider = Provider<UpdatePostUseCase>((ref) {
  return UpdatePostUseCase(ref.watch(postRepositoryProvider));
});

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  return DeletePostUseCase(ref.watch(postRepositoryProvider));
});

final getPostsBySubjectIdUseCaseProvider =
    Provider<GetPostsBySubjectIdUseCase>((ref) {
  return GetPostsBySubjectIdUseCase(ref.watch(postRepositoryProvider));
});

final getPostsByUserIdUseCaseProvider =
    Provider<GetPostsByUserIdUseCase>((ref) {
  return GetPostsByUserIdUseCase(ref.watch(postRepositoryProvider));
});

final yoloDetectionUseCaseProvider = Provider<yoloDetectionUseCase>((ref) {
  return yoloDetectionUseCase();
});
