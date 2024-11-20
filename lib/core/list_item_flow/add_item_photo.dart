import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapifymobile/common/constants/app_constants.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import 'dart:io';

import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/core/list_item_flow/post_item_page.dart';
import 'package:swapifymobile/core/list_item_flow/widgets/image_display.dart';
import 'package:swapifymobile/core/list_item_flow/widgets/image_upload_options.dart';
import 'package:swapifymobile/core/onboading_flow/categories_page.dart';
import 'package:swapifymobile/core/services/items_service.dart';

import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';
import '../../auth/services/auth_service.dart';
import 'add_item_event.dart';
import 'add_item_state.dart';
import 'item_bloc.dart';

class AddItemPhoto extends StatefulWidget {
  final Map<String, dynamic> itemData;
  final List<Map<String, String>> categories;

  const AddItemPhoto(
      {super.key, required this.itemData, required this.categories});

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
    _pageController.jumpToPage(index);
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

  Map<String, dynamic> combineJson(List<String> images) {
    widget.itemData['photos'] = images;
    return widget.itemData;
    // return jsonEncode(widget.itemData);
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
                child: _imageFiles!.isNotEmpty
                    ? GestureDetector(
                        child: ImageDisplay(
                          images: _imageFiles!,
                        ),
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Choose other image(s)'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _imageFiles?.clear();
                                    });
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(4), // Rounded corners
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
                            shadowColor:
                                Colors.transparent, // Removes button shadow
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text('${_imageFiles?.length ?? ''}'),
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
              // SizedBox(
              //   height: 20,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.itemData['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Row(children: [
                    Text("Item listed for"),
                    SizedBox(
                      width: 10,
                    ),
                    // if (widget.itemData['exchangeMethod'] == "Barter") ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border(),
                        color: AppColors.smallBtnBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        widget.itemData['exchangeMethod'] == "Both"
                            ? "Barter & Donation"
                            : widget.itemData['exchangeMethod'],
                        style: TextStyle(
                          color:
                              AppColors.primary, // Change text color as needed
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Item information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.itemData['description']),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Item condition",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.itemData['condition']),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Item category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("widget.categories."),
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
                        radius: 24,
                        onPressed: () {
                          if (context.read<AddItemBloc>().state
                              is! AddItemLoading) {
                            List<String> images = [
                              'https://via.placeholder.com/300x200.png?text=Image+1',
                              'https://via.placeholder.com/300x200.png?text=Image+2',
                              'https://via.placeholder.com/300x200.png?text=Image+3',
                              'https://via.placeholder.com/300x200.png?text=Image+4',
                            ];
                            Map<String, dynamic> payload = combineJson(images);

                            context
                                .read<AddItemBloc>()
                                .add(AddItemSubmit(payload));
                          }
                        },
                        content: BlocListener<AddItemBloc, AddItemState>(
                          listener: (context, state) {
                            if (state is AddItemFailure) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.error),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              });
                            } else if (state is AddItemSuccess) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Item created successfully!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              });
                            }
                          },
                          child: BlocBuilder<AddItemBloc, AddItemState>(
                            builder: (context, state) {
                              if (state is AddItemLoading) {
                                return SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                );
                              }

                              return Text(
                                "Create Item",
                                style: TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),

                      // BasicAppButton(
                      //   radius: 24,
                      //   // textColor: AppColors.background,
                      //   // title: "List Item",
                      //   onPressed: () {
                      //     if (context.read<AddItemBloc>().state
                      //         is! AddItemLoading) {
                      //       List<String> images = [
                      //         'https://via.placeholder.com/300x200.png?text=Image+1',
                      //         'https://via.placeholder.com/300x200.png?text=Image+2',
                      //         'https://via.placeholder.com/300x200.png?text=Image+3',
                      //         'https://via.placeholder.com/300x200.png?text=Image+4',
                      //       ];
                      //       Map<String, dynamic> payload = combineJson(images);
                      //
                      //       context
                      //           .read<AddItemBloc>()
                      //           .add(AddItemSubmit(payload));
                      //     }
                      //   },
                      //   content: BlocBuilder<AddItemBloc, AddItemState>(
                      //     builder: (context, state) {
                      //       if (state is AddItemLoading) {
                      //         return SizedBox(
                      //           height: 20,
                      //           width: 20,
                      //           child: CircularProgressIndicator(
                      //             color: Colors.white,
                      //             strokeWidth: 2,
                      //           ),
                      //         );
                      //       }
                      //
                      //       return Text(
                      //         "Create Item",
                      //         style: TextStyle(color: Colors.white),
                      //       );
                      //     },
                      //   ),
                      // ),

                      // BasicAppButton(
                      //   onPressed: () {
                      //     List<String> images = [
                      //       'https://via.placeholder.com/300x200.png?text=Image+1',
                      //       'https://via.placeholder.com/300x200.png?text=Image+2',
                      //       'https://via.placeholder.com/300x200.png?text=Image+3',
                      //       'https://via.placeholder.com/300x200.png?text=Image+4',
                      //     ];
                      //     String payload = combineJson(images);
                      //
                      //     sendToBackend(payload, context);
                      //
                      //     print(payload);
                      //     // AppNavigator.push(context, PostItemPage());
                      //   },
                      //   width: MediaQuery.of(context).size.width,
                      //   title:
                      //       _imageFiles!.isNotEmpty ? "List Item" : "Continue",
                      //   radius: 24,
                      //   backgroundColor: AppColors.primary,
                      //   textColor: AppColors.background,
                      // ),
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
      // bottomNavigationBar: BottomNavigation(
      //   // currentIndex: _currentIndex,
      //   onItemTapped: _onItemTapped,
      //   selectedItemColor:
      //       AppColors.primary, // Set custom color for the selected item
      //   unselectedItemColor:
      //       Colors.black, // Set custom color for unselected items
      //   backgroundColor: Colors.white, // Set custom background color
      // ),
    );
  }

  // late final ItemsService itemsService;

  // Future<void> sendToBackend(String payload, BuildContext context) async {
  //   try {
  //     // ResponseModel res = await itemsService.addItem(payload);
  //     // Initialize Dio
  //     final dio = Dio();
  //
  //     // Define the API endpoint
  //     final String apiUrl = ApiConstants.addItem;
  //
  //     // Make the POST request
  //     Response response = await dio.post(
  //       apiUrl,
  //       data: {'payload': payload}, // Send the payload
  //     );
  //
  //     // Check the response
  //     if (response.statusCode == 200) {
  //       // Assuming success if the status code is 200
  //       showSuccessMessage(context, "Submission successful!");
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => CategoriesPage(),
  //           ));
  //     } else {
  //       // Handle other status codes
  //       showErrorMessage(
  //           context, "Failed to submit data: ${response.statusMessage}");
  //     }
  //   } catch (e) {
  //     // Handle Dio or other exceptions
  //     showErrorMessage(context, "An error occurred: ${e.toString()}");
  //   }
  // }

  void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
