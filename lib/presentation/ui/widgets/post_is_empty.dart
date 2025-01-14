import 'package:drawee/constant/colors.dart';
import 'package:flutter/material.dart';

class PostIsEmpty extends StatelessWidget {
  const PostIsEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: AppColors.darkGray,
          size: 20,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '아직 게시글이 없습니다.\n첫 번째 게시글을 작성해보세요!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.darkGray,
          ),
        ),
      ],
    );
  }
}
