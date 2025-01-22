import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/app_colors.dart';

class ImageDisplay extends StatefulWidget {
  final List<XFile> images;

  ImageDisplay({Key? key, required this.images}) : super(key: key);

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  // final List<String> _images = [
  //   'https://via.placeholder.com/300x200.png?text=Image+1',
  //   'https://via.placeholder.com/300x200.png?text=Image+2',
  //   'https://via.placeholder.com/300x200.png?text=Image+3',
  //   'https://via.placeholder.com/300x200.png?text=Image+4',
  // ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.30,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(
                    File(widget.images[index].path),
                    fit: BoxFit.cover,
                  )

                  // Image.network(
                  //   widget.images[index],
                  //   fit: BoxFit.cover,
                  // ),
                  );
            },
          ),
        ),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 8 : 6,
              height: _currentPage == index ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? AppColors.primary : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
