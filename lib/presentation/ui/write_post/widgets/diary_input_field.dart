import 'package:drawee/constant/colors.dart';
import 'package:drawee/presentation/ui/write_post/widgets/hint_text.dart';
import 'package:flutter/material.dart';

class DiaryInputField extends StatelessWidget {
  const DiaryInputField({
    super.key,
    required TextEditingController titleController,
    required double height,
    required String hintText,
  })  : _titleController = titleController,
        _height = height,
        _text = hintText;

  final TextEditingController _titleController;
  final double _height;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: TextFormField(
        controller: _titleController,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$_text을 입력해주세요';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          hintText: "일기 $_text을 적어주세요",
          hintStyle: hintTextStyle,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
