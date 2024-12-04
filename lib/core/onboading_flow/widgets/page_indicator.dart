import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  PageIndicator({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) => _dotIndicator(index)),
    );
  }

  Widget _dotIndicator(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 10,
      width: currentPage == index ? 30 : 8, // Active dot is longer
      decoration: BoxDecoration(
        color: currentPage == index
            ? AppColors.successColor
            : AppColors.successColor,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
