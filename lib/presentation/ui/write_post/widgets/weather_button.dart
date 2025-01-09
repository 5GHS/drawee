import 'package:drawee/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class weatherButton extends StatelessWidget {
  final String weather;
  const weatherButton({
    required this.weather,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGray,
      ),
      child: IconButton(
          icon: SvgPicture.asset('assets/icon/${weather}.svg'),
          onPressed: () {}),
    );
  }
}
