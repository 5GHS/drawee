import 'dart:ui';

import 'package:drawee/presentation/ui/write_post/widgets/hint_text.dart';
import 'package:drawee/presentation/viewmodels/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drawee/constant/colors.dart';
import 'package:drawee/domain/entities/post.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostCard extends ConsumerWidget {
  final PostDetail post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(post.comments);
    return Container(
      key: ValueKey(post.postId),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.userImageUrl),
            ), // TODO: user Img 삽입 필요
            title: Text(
              post.userName, // TODO : user 이름 삽입 필요
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            subtitle: Text(
              _getTimeAgo(post.createdAt),
              style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
            ),
            trailing: SvgPicture.asset('assets/icon/${post.weather}.svg'),
          ),
          Stack(
            children: [
              // 배경 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  post.imageUrl,
                  width: double.infinity,
                  height: 360,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 360,
                      color: Colors.grey[300],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 40),
                          SizedBox(height: 8),
                          Text('이미지를 불러올 수 없습니다'),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Positioned(
                top: 16, // 위쪽 여백
                left: 16, // 왼쪽 여백
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color:
                            const Color.fromARGB(73, 247, 247, 247), // 대략 50%
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color.fromARGB(
                                75, 13, 187, 132)), // 대략 25%
                      ),
                      child: Text(
                        "#${post.subjectTopic}", // TODO: 이것도 subject -> topic으로 변경 필요
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black),
          ),
          const SizedBox(height: 4),
          Text(
            post.content,
            style: const TextStyle(fontSize: 14, color: AppColors.darkGray),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: 좋아요 누르기 (메소드 추가 필요할듯)
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icon/stamp.svg'),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likes}',
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.darkGray),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  // TODO: 댓글 페이지 이동
                  // Start Generation Here
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        '댓글',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '(${post.comments.length})',
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // 댓글 목록
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: post.comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = post.comments[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(comment.userImageUrl),
                                      ),
                                      title: Text(
                                        comment.userName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(comment.content),
                                    );
                                  },
                                ),
                              ),
                              // 댓글 입력 필드
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.gray,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: 좋아요 누르기
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                          child: Row(children: [
                                            //SizedBox(width: 2),
                                            SvgPicture.asset(
                                                'assets/icon/stamp.svg'),
                                            Text(
                                              '참 잘했어요',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: '댓글을 남겨보세요',
                                              hintStyle: hintTextStyle,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors.gray),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors.gray,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20), // 비활성 상태 테두리
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors.green,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20), // 활성 상태 테두리
                                              ),
                                            ),
                                          ),
                                        ),
                                        //SizedBox(width: 12),
                                        IconButton(
                                          icon: SvgPicture.asset(
                                              'assets/icon/commentSend.svg'),
                                          onPressed: () {
                                            // TODO: 댓글 전송 로직 추가
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icon/reply.svg'),
                    const SizedBox(width: 4),
                    Text(
                      '${post.comments.length}',
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.darkGray),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            height: 1,
            color: AppColors.lightGray,
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
