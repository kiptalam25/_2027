import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import 'dart:io';

import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/core/list_item_flow/post_item_page.dart';
import 'package:swapifymobile/core/list_item_flow/widgets/image_upload_options.dart';

import '../../common/widgets/navigation/bottom_navigation.dart';
import '../../main/pages/widgets/add_new_item_sheet.dart';

class AddItemPhoto extends StatefulWidget {
  @override
  _AddItemPhoto createState() => _AddItemPhoto();
}

class _AddItemPhoto extends State<AddItemPhoto> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController
        .jumpToPage(index); // Change to .animateToPage() for animation
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        // _showOverlay = !_showOverlay;
        _imageFiles = selectedImages;
      });
    }
  }

  File? _imageFile;

  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        // _imageFile = File(image.path);
        _imageFiles?.add(image);
      });
    }
  }

  String _selectedGesture = 'None';

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImageUploadOptions(
          onGestureSelected: (gesture) {
            // Update the main page based on the selected gesture
            setState(() {
              _selectedGesture = gesture;
              if (_selectedGesture == "gallery") {
                _pickImages();
              } else if (_selectedGesture == "camera") {
                _captureImage();
              }
            });
            Navigator.pop(context); // Close the bottom sheet
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: Text("Add photos of item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4), // Rounded corners
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFDDE5DB),
                        Color(0xFF50644C),
                      ],
                      stops: [0.0, 0.47, 1.0],
                    ),
                  ),
                  child: ElevatedButton(
                    // onPressed: _pickImages,
                    onPressed: _openBottomSheet,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Rounded corners
                      ),
                      backgroundColor:
                          Colors.transparent, // Important for gradient
                      shadowColor: Colors.transparent, // Removes button shadow
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${_imageFiles?.length ?? ''}'),
                        Icon(
                          Icons.add,
                          size: 38,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nike Fiesta",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Text("Item listed for"),
                      SizedBox(
                        width: 10,
                      ),
                      BasicAppButton(
                        title: "Barter",
                        width: 30,
                        height: 24,
                        radius: 24,
                        textColor: AppColors.primary,
                        backgroundColor: AppColors.successColor,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Item information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "The treasury or contact Supply Chain Management Office on the Ground Floor, Room No, 19  Head Quarters for assistance"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Item condition",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("Barely Worn"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Item category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("Men's fashion,Footwear,Sports"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Categories of Interest",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("Men's fashion,Home appliances,Kitchen Utensils"),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BasicAppButton(
                        onPressed: () {
                          AppNavigator.push(context, PostItemPage());
                        },
                        width: MediaQuery.of(context).size.width,
                        title: "Continue",
                        radius: 24,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.background,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      BasicAppButton(
                        onPressed: () {},
                        width: MediaQuery.of(context).size.width,
                        title: "Save as draft",
                        radius: 24,
                        backgroundColor: AppColors.background,
                        textColor: AppColors.primary,
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  )
                ],
              )
              // Expanded(
              //   child: GridView.builder(
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 3,
              //       crossAxisSpacing: 4,
              //       mainAxisSpacing: 4,
              //     ),
              //     itemCount: _imageFiles?.length ?? 0,
              //     itemBuilder: (context, index) {
              //       return Image.file(
              //         File(_imageFiles![index].path),
              //         fit: BoxFit.cover,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
        selectedItemColor:
            AppColors.primary, // Set custom color for the selected item
        unselectedItemColor:
            Colors.black, // Set custom color for unselected items
        backgroundColor: Colors.white, // Set custom background color
      ),
    );
  }
}
