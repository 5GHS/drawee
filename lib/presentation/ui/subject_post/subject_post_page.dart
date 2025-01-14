import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/subject_search/subject_search_page.dart';
import 'package:drawee/presentation/ui/widgets/post_card.dart';
import 'package:drawee/presentation/ui/widgets/post_is_empty.dart';
import 'package:drawee/presentation/viewmodels/post_view_model.dart';
import 'package:drawee/presentation/viewmodels/recommend_subject_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectPostPage extends ConsumerStatefulWidget {
  const SubjectPostPage({super.key});

  @override
  ConsumerState<SubjectPostPage> createState() => _SubjectPostPageState();
}

class _SubjectPostPageState extends ConsumerState<SubjectPostPage> {
  String topic = '';
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () async {
        await ref
            .read(recommendSubjectViewModelProvider.notifier)
            .getRecommendSubject();

        ref.read(recommendSubjectViewModelProvider).whenData((data) {
          setState(() {
            topic = data?.topic ?? '로딩 중';
          });
          if (data?.subjectId != null) {
            ref
                .read(postViewModelProvider.notifier)
                .getPostsBySubject(data!.subjectId);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final recommendSubject = ref.watch(recommendSubjectViewModelProvider);

    final postsAsync = ref.watch(postViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '주제별 보기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // ------------------
            // 검색 버튼
            // ------------------
            GestureDetector(
              onTap: () async {
                final newTopic =
                    await Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const SubjectSearchPage();
                  },
                ));
                if (newTopic != null) {
                  setState(() {
                    topic = newTopic;
                  });
                  print('newTopic: $topic');
                }
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 2,
                  bottom: 2,
                ),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.lightGray,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '관심있는 주제를 검색해보세요',
                      style: TextStyle(
                        color: AppColors.darkGray,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 40,
                      child: const Icon(
                        Icons.search,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ------------------
            // 오늘의 주제
            // ------------------
            const Text(
              '오늘의 주제',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: const Color.fromARGB(75, 13, 187, 132)),
              ),
              child: Text(
                '# $topic',
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // ------------------
            // 주제별 게시글
            // ------------------
            Expanded(
              child: postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return const PostIsEmpty();
                  }
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: posts[index]);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
