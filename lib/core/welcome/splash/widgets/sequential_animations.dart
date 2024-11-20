import 'package:flutter/material.dart';
import 'dart:math' as math;

class SequentialAnimations extends StatefulWidget {
  @override
  _SequentialAnimationsState createState() => _SequentialAnimationsState();
}

class _SequentialAnimationsState extends State<SequentialAnimations>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late Animation<double> _imageSizeAnimation;

  late AnimationController _rectangleController;
  late Animation<double> _rectangleSizeAnimation;
  late Animation<double> _rectangleRotationAnimation;
  bool _showRectangle = true;

  @override
  void initState() {
    super.initState();

    // Image animation controller
    _imageController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _imageSizeAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOut),
    );

    // Rectangle animation controller
    _rectangleController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _rectangleSizeAnimation = Tween<double>(begin: 0.0, end: 1000.0).animate(
      CurvedAnimation(parent: _rectangleController, curve: Curves.easeOut),
    );

    _rectangleRotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(
            parent: _rectangleController, curve: Curves.linear));

    // Add listener to rectangle animation to hide it when max size is reached
    _rectangleSizeAnimation.addListener(() {
      if (_rectangleSizeAnimation.isCompleted) {
        setState(() {
          _showRectangle = false;
        });
      }
    });

    // Start image animation, then start rectangle animation after it finishes
    _imageController.forward().whenComplete(() {
      // _imageController.dispose();
      // _rectangleController.repeat(reverse: false);
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _rectangleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sequential Animations'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rectangle animation
            if (_showRectangle)
              AnimatedBuilder(
                animation: _rectangleController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rectangleRotationAnimation.value,
                    child: Container(
                      width: _rectangleSizeAnimation.value,
                      height: _rectangleSizeAnimation.value,
                      color: Colors.blue.withOpacity(0.5),
                    ),
                  );
                },
              ),

            // Image animation
            AnimatedBuilder(
              animation: _imageSizeAnimation,
              builder: (context, child) {
                return SizedBox(
                  height: _imageSizeAnimation.value,
                  child: Image.network(
                    'https://via.placeholder.com/150', // Replace with your image URL
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
