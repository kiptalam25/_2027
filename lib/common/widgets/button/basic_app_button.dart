import 'package:flutter/material.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Widget? content;
  final double? height;
  final double? width;
  final double? radius;
  final Color? backgroundColor;
  final Color? textColor;
  const BasicAppButton(
      {required this.onPressed,
      this.title = '',
      this.height,
      this.width,
      this.content,
      this.radius,
      this.backgroundColor,
      this.textColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: Color(0xFF50644C), // Custom border color
          width: 2, // Border width
        ),
        backgroundColor: backgroundColor ??
            AppColors.primary, // Use passed background color or fallback
        minimumSize:
            Size(width ?? MediaQuery.of(context).size.width, height ?? 46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 10), // Rounded corners
        ),
      ),
      child: content ??
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: textColor ??
                  Colors.white, // Use passed text color or fallback
              fontWeight: FontWeight.w400,
            ),
          ),
    );
  }
}
