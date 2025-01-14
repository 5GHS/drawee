import 'package:drawee/constant/colors.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Icon(
              Icons.search,
              color: AppColors.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}
