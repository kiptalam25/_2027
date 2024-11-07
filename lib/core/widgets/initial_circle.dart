import 'package:flutter/material.dart';

class InitialCircle extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final TextStyle textStyle;

  const InitialCircle({
    Key? key,
    required this.text,
    this.size = 50.0,
    this.color = Colors.blue, // Replace with AppColors.primary if needed
    this.textStyle = const TextStyle(fontSize: 24, color: Colors.white),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text.isNotEmpty ? text[0].toUpperCase() : '',
        style: textStyle,
      ),
    );
  }
}
