import 'package:drawee/presentation/providers/post_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drawee/domain/entities/post.dart';

class PostViewModel extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    return await ref.read(getPostsUseCaseProvider).execute();
  }

  Future<void> getPostsByWeather(String weather) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getPostsByWeatherUseCaseProvider).execute(weather),
    );
  }

  Future<void> getPostsBySubject(String subjectId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getPostsBySubjectIdUseCaseProvider).execute(subjectId),
    );
  }

  Future<Post?> getPost(String postId) async {
    return await ref.read(getPostUseCaseProvider).execute(postId);
  }

  Future<void> getPostsByUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(getPostsByUserIdUseCaseProvider).execute(userId));
  }

  Future<void> createPost(Post post) async {
    await ref.read(createPostUseCaseProvider).execute(post);
  }

  Future<void> updatePost(Post post) async {
    await ref.read(updatePostUseCaseProvider).execute(post);
  }

  Future<void> deletePost(String postId) async {
    await ref.read(deletePostUseCaseProvider).execute(postId);
  }
}

final postViewModelProvider =
    AsyncNotifierProvider<PostViewModel, List<Post>>(() => PostViewModel());
