import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drawee/presentation/ui/widgets/post_card.dart';
import 'package:drawee/presentation/providers/post_providers.dart';

class LikedPostsPage extends ConsumerWidget {
  final List<String> postIds;

  const LikedPostsPage({Key? key, required this.postIds}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(getPostsByIdsProvider(postIds));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '참 잘했어요 누른 글',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: postsAsync.when(
        data: (posts) {
          print('posts: $posts');
          print('post ids: $postIds');
          if (posts.isEmpty) {
            return const Center(child: Text('참 잘했어요 누른 글이 없습니다.'));
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
