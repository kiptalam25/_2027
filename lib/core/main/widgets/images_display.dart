import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagesDisplay extends StatefulWidget {
  final List<dynamic> images; // Accepts both File and String
  final double height;
  final Color activeDotColor;
  final Color inactiveDotColor;
  final Function(int)? onRemove; // Optional callback for removing images
  final bool showRemoveButton; // Controls visibility of the "X" button

  const ImagesDisplay({
    Key? key,
    required this.images,
    this.height = 200.0,
    this.activeDotColor = Colors.blue,
    this.inactiveDotColor = Colors.grey,
    this.onRemove,
    this.showRemoveButton = false, // Default is false
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
              return Stack(
                children: [
                  // Display the image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: image is String
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : image is XFile
                            ? Image.file(
                                File(image.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : const Center(
                                child: Text('Unsupported Image Type'),
                              ),
                  ),
                  // Conditionally show the "X" button
                  if (widget.showRemoveButton && widget.onRemove != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => widget.onRemove!(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
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
