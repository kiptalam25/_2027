import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/config/themes/app_colors.dart';

class CustomHamburger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Use minimal space
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 25,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
        SizedBox(height: 4), // Space between bars
        Container(
          width: 20,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: 15,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
      ],
    );
  }
}
