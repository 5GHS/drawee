import 'dart:ffi';

import 'package:drawee/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class weatherButton extends StatelessWidget {
  final String weather;
  final bool isSelected;
  final VoidCallback onTap;

  const weatherButton({
    required this.weather,
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.green : AppColors.lightGray,
      ),
      child: IconButton(
          icon: SvgPicture.asset('assets/icon/${weather}.svg'),
          onPressed: onTap),
    );
  }
}
