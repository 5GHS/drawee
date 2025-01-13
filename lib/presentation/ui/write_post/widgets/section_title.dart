import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: sectionTitleStyle, // 공통 스타일 사용
      ),
    );
  }
}

const TextStyle sectionTitleStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 16,
  fontFamily: 'Pretendard',
);
