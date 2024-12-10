import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/api_constants/api_constants.dart';
import 'dart:io';

import 'package:swapifymobile/common/widgets/app_bar.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/core/list_item_flow/listed_items_page.dart';
import 'package:swapifymobile/core/list_item_flow/widgets/confirm_item_delete.dart';
import 'package:swapifymobile/core/list_item_flow/widgets/image_upload_options.dart';
import 'package:swapifymobile/core/main/item_card.dart';
import 'package:swapifymobile/core/services/category_service.dart';
import 'package:swapifymobile/core/services/items_service.dart';
import 'package:swapifymobile/core/usecases/item.dart';
import 'package:swapifymobile/extensions/string_casing_extension.dart';

import '../main/widgets/images_display.dart';
import 'add_new_item_sheet.dart';

class AddItemPhoto extends StatefulWidget {
  final String itemId;
  final String action;
  // final List<Map<String, String>> categories;

  const AddItemPhoto({super.key, required this.itemId, required this.action});

  @override
  _AddItemPhoto createState() => _AddItemPhoto();
}

class _AddItemPhoto extends State<AddItemPhoto> {
  // int _currentIndex = 0;
  bool isLoading = true;
  Item? item;
  final ItemsService itemsService = ItemsService(new ApiClient());
  final CategoryService categoryService = CategoryService(new ApiClient());
  final PageController _pageController = PageController();

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  //   _pageController.jumpToPage(index);
  // }

  final ImagePicker _picker = ImagePicker();
  List<dynamic>? _imageFiles = [];
  bool isNewItem = true;

  @override
  void initState() {
    _fetchItem(widget.itemId);
    switch (widget.action) {
      case 'new':
        isNewItem = true;
        break;
      case 'old':
        isNewItem = false;
        break;
      default:
        isNewItem = true;
    }
    super.initState();
  }

  Future<void> _fetchItem(String itemId) async {
    try {
      item = await itemsService.fetchItem(itemId);
      setState(() {
        isLoading = false;
        _uploadedImageUrls = item!.imageUrls;
      });
    } catch (e) {
      print('Error fetching item: $e');
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _imageFiles = selectedImages;
      });
    }
  }

  List<String> _uploadedImageUrls = [];

  bool _uploadingImages = false;
  final dio = Dio();

  Future<void> deleteImage(String publicId) async {
    final formData = FormData.fromMap({
      'public_id': publicId,
      'upload_preset': ApiConstants.itemUploadPreset, // Your Upload Preset
    });
    try {
      final response = await dio.post(
        "${ApiConstants.imageDeleteUrl}",
        data: formData, // Pass the ID if required
      );

      if (response.statusCode == 200) {
        print("Image deleted successfully");
      } else {
        print("Failed to delete image: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
  }

  Future<void> _uploadImages() async {
    setState(() {
      _uploadingImages = true;
    });

    const uploadPreset = ApiConstants.itemUploadPreset;

    List<String> uploadedUrls = [];

    try {
      for (var image in _imageFiles!) {
        final formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(image.path),
          "upload_preset": uploadPreset,
        });

        final response = await dio.post(
          ApiConstants.imageUploadUrl,
          data: formData,
        );

        if (response.statusCode == 200) {
          // Extract URL from the response
          String imageUrl = response.data['secure_url'];
          uploadedUrls.add(imageUrl);
        }
      }
      setState(() {
        _uploadedImageUrls = uploadedUrls;
      });
      if (_uploadedImageUrls.isNotEmpty) {
        final jsonResult = getUrlsAsJson();
        final response2 = await itemsService.updateItem(jsonResult, item!.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response2.message}'),
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ListedItemsPage(),
            ));

        setState(() {
          _uploadingImages = false;
        });
      }

      print("Uploaded URLs: $_uploadedImageUrls");
    } catch (e) {
      print("Error uploading images: $e");
    }
  }

  String getUrlsAsJson() {
    final Map<String, dynamic> jsonMap = {
      "imageUrls": _uploadedImageUrls,
    };
    return jsonEncode(jsonMap);
  }

  // Map<String, dynamic> combineJson(List<String> images) {
  //   widget.itemData['photos'] = images;
  //   return widget.itemData;
  //   // return jsonEncode(widget.itemData);
  // }

  // File? _imageFile;

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

  Future<void> _removeImage(int index) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove This Image?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await deleteImage(item!.imageUrls[index]);
              Navigator.pop(context);
              setState(() {
                item!.imageUrls.removeAt(index);
              });
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: isNewItem ? true : false,
        title: Text("Add photos of item"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: _imageFiles!.isNotEmpty ||
                              item!.imageUrls.isNotEmpty
                          ? ImagesDisplay(
                              images: _imageFiles!.isNotEmpty
                                  ? _imageFiles!
                                  : item!.imageUrls,
                              onRemove: _removeImage,
                              showRemoveButton: true,
                            )

                          // child: ImageDisplay(
                          //   images: _imageFiles!,
                          // ),
                          // onTap: () async {
                          //   await showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //       title: Text('Choose other image(s)'),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //           },
                          //           child: Text('No'),
                          //         ),
                          //         TextButton(
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //             setState(() {
                          //               _imageFiles?.clear();
                          //             });
                          //           },
                          //           child: Text('Yes'),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // },
                          // )
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
                                    borderRadius: BorderRadius.circular(
                                        4), // Rounded corners
                                  ),
                                  backgroundColor: Colors
                                      .transparent, // Important for gradient
                                  shadowColor: Colors
                                      .transparent, // Removes button shadow
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
                          "${item?.title.toTitleCase}",
                          // widget.itemData['title'],
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
                          Text("Item listed for"),
                          SizedBox(
                            width: 10,
                          ),
                          // if (item.exchangeMethod == "Barter") ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: AppColors.primary),
                              color: AppColors.smallBtnBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              {item?.exchangeMethod} == "both"
                                  ? "Barter & Donation"
                                  : "${item?.exchangeMethod.toTitleCase}",
                              style: TextStyle(
                                color: AppColors
                                    .primary, // Change text color as needed
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Item Information",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text("${item?.description.toCapitalized}"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Item Condition",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text("${item?.condition.toTitleCase}"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Item category",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text("${item?.categoryId}"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(item!.subCategoryId),
                        // FutureBuilder<List<Map<String, String>>>(
                        //   future: categoryService.fetchCategories(),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState ==
                        //         ConnectionState.waiting) {
                        //       return CircularProgressIndicator();
                        //     } else if (snapshot.hasError) {
                        //       return Text("Error: ${snapshot.error}");
                        //     } else if (!snapshot.hasData ||
                        //         snapshot.data!.isEmpty) {
                        //       return Text("No categories available");
                        //     } else {
                        //       // Filter category by subCategoryId
                        //       final categories = snapshot.data!;
                        //       final matchingCategory = categories.firstWhere(
                        //         (category) =>
                        //             category['_id'] == item!.categoryId,
                        //         orElse: () => {},
                        //       );
                        //
                        //       if (matchingCategory.isEmpty) {
                        //         return Text("Category not found");
                        //       } else {
                        //         return Text(
                        //             matchingCategory['name'] ?? "Unknown");
                        //       }
                        //     }
                        //   },
                        // ),
                        // Text(
                        //   "Item SubCategory",
                        //   style: TextStyle(
                        //       fontSize: 16, fontWeight: FontWeight.bold),
                        // ),
                        // Text("${item?.subCategoryId}"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Categories of Interest",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (item!.swapInterests.isEmpty)
                          Text("No swap interests available"),
                        // Loop through swapInterests
                        ...item!.swapInterests.map((interest) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              " $interest,",
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                        SizedBox(
                          height: 20,
                        ),
                        if (isNewItem) ...[
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BasicAppButton(
                                  radius: 24,
                                  onPressed: _uploadingImages
                                      ? null
                                      : () {
                                          _uploadImages();
                                        },
                                  content: _uploadingImages
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "Upload",
                                          style: TextStyle(
                                              color: AppColors.background),
                                        )),
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
                            ],
                          )
                        ],

                        if (!isNewItem) ...[
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                flex: 1,
                                child: BasicAppButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (BuildContext context) {
                                        return ConfirmItemDelete(
                                          onConfirmDelete: () {
                                            deleteItem(item!.id);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  title: "Delete item",
                                  radius: 24,
                                  backgroundColor: AppColors.background,
                                  textColor: AppColors.primary,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 1,
                                child: BasicAppButton(
                                    height: 40,
                                    radius: 24,
                                    onPressed: _uploadingImages
                                        ? null
                                        : () {
                                            Navigator.pop(context);
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddNewItemSheet(
                                                  isNew: false,
                                                  item: item,
                                                );
                                              },
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                              // borderRadius: BorderRadius.zero),
                                              isScrollControlled:
                                                  true, // Makes the bottom sheet more flexible in height
                                            );
                                          },
                                    content: _uploadingImages
                                        ? CircularProgressIndicator()
                                        : Text(
                                            "Edit item",
                                            style: TextStyle(
                                                color: AppColors.background),
                                          )),
                              ),
                            ],
                          )
                        ],
                        SizedBox(
                          height: 16,
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

  Future<void> deleteItem(String id) async {
    var response = await itemsService.deleteItem(id);
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.message}'),
        ),
      );
      Navigator.pop(context, 'refresh');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.message}'),
        ),
      );
    }
  }
}
