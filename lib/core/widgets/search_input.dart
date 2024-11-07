import 'package:flutter/material.dart';

import '../config/themes/app_colors.dart';

class SearchInput extends StatelessWidget {
  final String hintText;
  final Color fillColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final Icon prefixIcon;
  final TextEditingController? controller;

  const SearchInput({
    Key? key,
    this.hintText = 'Search...',
    this.fillColor = Colors.white,
    this.borderColor =
        AppColors.primary, // Replace with your AppColors.primary if you have it
    this.borderRadius = 24.0,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    this.prefixIcon = const Icon(Icons.search),
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: fillColor,
          contentPadding: contentPadding,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1.0),
          ),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
