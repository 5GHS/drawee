import 'package:drawee/presentation/viewmodels/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drawee/presentation/ui/widgets/post_card.dart';
import 'package:drawee/presentation/providers/post_providers.dart';

class WrittenPostsPage extends ConsumerWidget {
  final List<String> postIds;

  const WrittenPostsPage({super.key, required this.postIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(postViewModelProvider.notifier).getPostsByIds(postIds);

    final postsAsync = ref.watch(postViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내가 쓴 글',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: postsAsync.when(
        data: (posts) {
          print('posts: $posts');
          print('post ids: $postIds');
          if (posts.isEmpty) {
            return const Center(child: Text('작성한 글이 없습니다.'));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: posts[index]);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          print('Error fetching posts: $error');
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
