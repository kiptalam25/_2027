import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagesDisplay extends StatefulWidget {
  final List<dynamic> images; // Accepts both File and String
  final double height;
  final Color activeDotColor;
  final Color inactiveDotColor;

  const ImagesDisplay({
    Key? key,
    required this.images,
    this.height = 200.0,
    this.activeDotColor = Colors.blue,
    this.inactiveDotColor = Colors.grey,
  }) : super(key: key);

  @override
  _ImagesDisplayState createState() => _ImagesDisplayState();
}

class _ImagesDisplayState extends State<ImagesDisplay> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: image is String
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                      )
                    : image is XFile
                        ? Image.file(
                            File(image.path),
                            fit: BoxFit.cover,
                          )
                        : const Center(child: Text('Unsupported Image Type')),
              );
            },
          ),
        ),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 8 : 6,
              height: _currentPage == index ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? widget.activeDotColor
                    : widget.inactiveDotColor,
              ),
            );
          }),
        ),
      ],
    );
  }
}
