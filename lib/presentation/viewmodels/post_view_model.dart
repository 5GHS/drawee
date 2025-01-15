import 'package:drawee/presentation/providers/post_providers.dart';
import 'package:drawee/presentation/providers/subject_providers.dart';
import 'package:drawee/presentation/providers/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drawee/domain/entities/post.dart';

class CommentDetail {
  final String content;
  final DateTime createdAt;
  final String userId;
  final String userImageUrl;
  final String userName;

  const CommentDetail({
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.userImageUrl,
    required this.userName,
  });
}

class PostDetail {
  final String postId;
  final List<CommentDetail> comments;
  final String content;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String title;
  final String imageUrl;
  final String subjectId;
  final String subjectTopic;
  final String weather;
  final int likes;
  final DateTime createdAt;

  const PostDetail({
    required this.postId,
    required this.comments,
    required this.content,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.title,
    required this.imageUrl,
    required this.subjectId,
    required this.subjectTopic,
    required this.weather,
    required this.likes,
    required this.createdAt,
  });

  PostDetail copyWith({
    String? postId,
    List<CommentDetail>? comments,
    String? content,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? title,
    String? imageUrl,
    String? subjectId,
    String? subjectTopic,
    String? weather,
    int? likes,
    DateTime? createdAt,
  }) {
    return PostDetail(
      postId: postId ?? this.postId,
      comments: comments ?? this.comments,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      subjectId: subjectId ?? this.subjectId,
      subjectTopic: subjectTopic ?? this.subjectTopic,
      weather: weather ?? this.weather,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PostViewModel extends AsyncNotifier<List<PostDetail>> {
  @override
  Future<List<PostDetail>> build() async {
    return getPosts();
  }

  Future<List<PostDetail>> getPosts() async {
    state = const AsyncValue.loading();

    final posts = await ref.read(getPostsUseCaseProvider).execute();

    state = AsyncValue.data(await _convertPostsToPostDetails(posts));
    return await _convertPostsToPostDetails(posts);
  }

  Future<void> getPostsByIds(List<String> postIds) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final posts =
          await ref.read(getPostsByIdsUseCaseProvider).execute(postIds);
      return await _convertPostsToPostDetails(posts);
    });
  }

  Future<void> getPostsByWeather(String weather) async {
    state = const AsyncValue.loading();
    try {
      final posts =
          await ref.read(getPostsByWeatherUseCaseProvider).execute(weather);
      state = AsyncValue.data(await _convertPostsToPostDetails(posts));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> getPostsBySubject(String subjectId) async {
    //state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final posts =
          await ref.read(getPostsBySubjectIdUseCaseProvider).execute(subjectId);
      return await _convertPostsToPostDetails(posts);
    });
  }

  Future<Post?> getPost(String postId) async {
    return await ref.read(getPostUseCaseProvider).execute(postId);
  }

  Future<void> getPostsByUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final posts =
          await ref.read(getPostsByUserIdUseCaseProvider).execute(userId);
      return await _convertPostsToPostDetails(posts);
    });
  }

  Future<bool> createPost(Post post) async {
    return await ref.read(createPostUseCaseProvider).execute(post);
  }

  Future<bool> updatePost(Post post) async {
    final result = await ref.read(updatePostUseCaseProvider).execute(post);
    if (result) {
      final posts = await ref.read(getPostsUseCaseProvider).execute();
      state = AsyncValue.data(await _convertPostsToPostDetails(posts));
    }
    return result;
  }

  Future<bool> deletePost(String postId) async {
    final result = await ref.read(deletePostUseCaseProvider).execute(postId);
    if (result) {
      final posts = await ref.read(getPostsUseCaseProvider).execute();
      state = AsyncValue.data(await _convertPostsToPostDetails(posts));
    }
    return result;
  }

  Future<List<PostDetail>> _convertPostsToPostDetails(List<Post> posts) async {
    List<PostDetail> postDetails = [];

    print(posts.length);
    for (var post in posts) {
      try {
        final user =
            await ref.read(getUserUseCaseProvider).execute(post.userId);

        final subject =
            await ref.read(getSubjectUsecaseProvider).execute(post.subjectId);

        final comments = post.comments.map((comment) {
          return CommentDetail(
            content: comment.content,
            createdAt: comment.createdAt,
            userId: comment.userId,
            userImageUrl: user?.imgUrl ?? '',
            userName: user?.name ?? '',
          );
        }).toList();

        final postDetail = PostDetail(
          postId: post.postId,
          comments: comments,
          content: post.content,
          userId: post.userId,
          userName: user?.name ?? '',
          userImageUrl: user?.imgUrl ?? '',
          title: post.title,
          imageUrl: post.imageUrl,
          subjectId: post.subjectId,
          subjectTopic: subject?.topic ?? '',
          weather: post.weather,
          likes: post.likes,
          createdAt: post.createdAt,
        );

        postDetails.add(postDetail);
      } catch (e) {
        print("Error converting post: $e");
      }
    }

    return postDetails;
  }
}

final postViewModelProvider =
    AsyncNotifierProvider<PostViewModel, List<PostDetail>>(
        () => PostViewModel());
