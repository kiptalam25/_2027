import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/app_bar.dart';

class AnimatingPhoto extends StatefulWidget {
  @override
  _AnimatingPhotoState createState() => _AnimatingPhotoState();
}

class _AnimatingPhotoState extends State<AnimatingPhoto>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    _sizeAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(),
      body: Center(
        child: AnimatedBuilder(
          animation: _sizeAnimation,
          builder: (context, child) {
            return SizedBox(
              height: _sizeAnimation.value,
              child: Image.network(
                'https://via.placeholder.com/150', // Replace with your image URL
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
