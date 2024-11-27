import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/core/list_item_flow/add_item_photo.dart';
import 'package:swapifymobile/core/services/category_service.dart';

import '../../api_constants/api_constants.dart';
import '../onboading_flow/choose_categories.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/dialog.dart';
import 'add_item_event.dart';
import 'add_item_state.dart';
import 'item_bloc.dart';

class AddNewItemSheet extends StatefulWidget {
  // final PageController pageController;
  //
  // AddNewItemSheet({}) {
  //   // TODO: implement AddNewItemSheet
  //   throw UnimplementedError();
  // }

  @override
  _AddNewItemSheetState createState() => _AddNewItemSheetState();
}

class _AddNewItemSheetState extends State<AddNewItemSheet> {
  // pageController = this.pageController;
  bool isBarterChecked = false;
  bool isDonationChecked = false;
  final _formKey = GlobalKey<FormState>();
  // final int _maxCharacters = 500;

  bool isFirstStep = true;
  bool _isLoading = true;
  bool _isFetchingSubCategories = false;
  late Map<String, dynamic> itemData;

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceRange = TextEditingController();

  // Method to create JSON from the selected checkboxes
  String getCheckboxJson() {
    Map<String, String> selectedItems;
    if (isDonationChecked && isBarterChecked) {
      selectedItems = {
        'exchangeMethod': "both",
      };
    } else if (isBarterChecked) {
      selectedItems = {
        'exchangeMethod': "swap",
      };
    } else if (isDonationChecked) {
      selectedItems = {
        'exchangeMethod': "donation",
      };
    } else {
      selectedItems = {
        'exchangeMethod': "",
      };
    }

    return jsonEncode(selectedItems); // Convert map to JSON string
  }

  String getCategoriesOfInterestAsJson() {
    Map<String, List<String>> selectedItems = {
      'swapInterests': selectedCategoryIds
    };
    return jsonEncode(selectedItems); // Convert map to JSON string
  }

  String getAdditionalFieldsJson() {
    Map<String, dynamic> additionalData = {
      'title': itemNameController.text,
      'description': descriptionController.text,
      'condition': selectedCondition,
      'priceRange': priceRange.text,
      'categoryId': selectedCategory!,
      'subCategoryId': itemSubCategory!,
      'tags': "....",
      'additionalInformation': "....",
      'warrantStatus': false,
    };
    return jsonEncode(additionalData);
  }

  // Method to combine JSON objects
  Map<String, dynamic> combineJson(String json1, String json2, String json3) {
    itemData = {
      ...jsonDecode(json1),
      ...jsonDecode(json2),
      ...jsonDecode(json3)
    };
    return itemData;
  }

  List<Map<String, String>> _categories = [];
  List<Map<String, String>> _conditions = [
    {'id': 'new', 'name': 'New'},
    {'id': 'like new', 'name': 'Like New'},
    {'id': 'used', 'name': 'Used'},
    {'id': 'fair', 'name': 'Fair'},
    {'id': 'poor', 'name': 'Poor'},
  ];
  List<Map<String, String>> _subCategories = [];
  String? selectedCategoryId;
  late String? selectedCondition = _conditions.first['id'];
  late String? selectedCategory = "";
  late String? selectedCategoryOfInterest;
  late String? itemSubCategory = "";

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories from the database
  }

  final CategoryService categoryService = CategoryService(ApiClient());

  Future<void> _fetchCategories() async {
    await Future.delayed(Duration(seconds: 1));
    List<Map<String, String>> categories =
        await categoryService.fetchCategories();
    setState(() {
      _categories = categories;
      //     [
      //   {'id': '1', 'name': 'Bicycles'},
      //   {'id': '2', 'name': 'Toys'},
      // ];
      _isLoading = false;

      if (_categories.isNotEmpty) {
        // selectedCondition = _conditions.first['id']!;
        selectedCategory = _categories.first['id']!;
        findSubCAtegories(selectedCategory!);
        selectedCategoryOfInterest = _categories.first['id']!;
        // itemSubCategory = _categories.first['id']!;
      }
    });
  }

  // late String? selectedCondition = _categories.first['id']!;
  // late String? selectedCategory = _categories.first['id']!;
  // late String? selectedCategoryOfInterest = _categories.first['id']!;
  // late String? itemSubCategory = _categories.first['id']!;

  // List<DropdownMenuItem<int>> _buildDropdownItems() {
  //   return _categories.map((category) {
  //     return DropdownMenuItem<int>(
  //       value: category['id'],
  //       child: Text(category['name']),
  //     );
  //   }).toList();
  // }

  List<String> selectedCategoryIds = [];

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   // Show a loading spinner while fetching categories
    //   return Center(child: CircularProgressIndicator());
    // }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            16.0, // Adjust for keyboard
        left: 16.0,
        right: 16.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Makes the sheet's height flexible
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Container(
                      height: 3,
                      width: 40,
                      color: AppColors.dashColor, // Set the background color
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                    child: Align(
                      alignment: Alignment
                          .bottomCenter, // Align the text at the bottom
                      child: Text(
                        'List New Item',
                        style:
                            TextStyle(fontSize: 16, color: AppColors.primary),
                      ),
                    ),
                  ),
                  Divider(
                    // Line under the title
                    color: AppColors.dividerColor, // Color of the line
                    thickness: 2, // Thickness of the line
                  ),
                ],
              ),

              // const SizedBox(height: 48),
              if (isFirstStep) ...[
                CheckboxListTile(
                  title: Text('Barter'),
                  value: isBarterChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isBarterChecked = value ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  title: Text('Donation'),
                  value: isDonationChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isDonationChecked = value ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                )
              ] else ...[
                SizedBox(
                  height: 16,
                ),
                InputSection(
                  label: "Item Name*",
                  hintText: "Enter item name",
                  controller: itemNameController,
                  maxCharacters: 0, // Optional
                ),

                // _buildInputSection(
                //     "Item Name*", "Enter item name", itemNameController, 0),
                SizedBox(
                  height: 16,
                ),
                // TextField(
                // controller: descriptionController,
                InputSection(
                  label: "Description*",
                  hintText: "Briefly describe the item",
                  controller: descriptionController,
                  maxCharacters: 500, // Optional
                ),
                // _buildInputSection("Description*", "Briefly describe the item",
                //     descriptionController, 500),
                SizedBox(
                  height: 16,
                ),
                // Text("Condition*"),
                // InputSection(
                //   label: "Condition*",
                //   hintText: "Item Condition",
                //   controller: itemCondition,
                //   maxCharacters: 0,
                // ),
                // _conditions.isEmpty
                // ? SizedBox(
                // height: 20, width: 20, child: CircularProgressIndicator())
                CustomDropdown(
                  value: selectedCondition,
                  items: _conditions,
                  // hintText: 'Item Category*',
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCondition = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                if (isBarterChecked) ...[
                  InputSection(
                    label: "Price Range",
                    hintText: "Enter price range of the item",
                    controller: priceRange,
                    maxCharacters: 0,
                  ),
                  // _buildInputSection("Price Range",
                  //     "Enter price range of the item", priceRange, 0),
                ],
                const SizedBox(
                  height: 16,
                ),
                Text("Item Category*"),
                _categories.isEmpty
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())
                    : CustomDropdown(
                        value: selectedCategory,
                        items: _categories,
                        // hintText: 'Item Category*',
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            _subCategories = [];
                            findSubCAtegories(newValue);
                          });
                        },
                      ),
                const SizedBox(
                  height: 16,
                ),
                Text("Item Sub-category*"),
                _subCategories.isEmpty && _isFetchingSubCategories
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())
                    // if (itemSubCategory!.isNotEmpty)
                    : CustomDropdown(
                        value: itemSubCategory,
                        items: _subCategories,
                        // hintText: 'Item Category*',
                        onChanged: (String? newValue) {
                          setState(() {
                            itemSubCategory = newValue!;
                          });
                        },
                      ),
                SizedBox(
                  height: 16,
                ),

                if (isBarterChecked) ...[
                  Text("Categories of interest (Barter only)"),
                  SingleChildScrollView(
                    child: _categories.isEmpty
                        ? Center(
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator()))
                        : FilteredItemSelector(
                            returnType: "name",
                            allItems: _categories,
                            onItemAdded: (selectedIds) {
                              setState(() {
                                selectedCategoryIds =
                                    selectedIds; // Update selected IDs
                              });
                            },
                            onItemRemoved: (selectedIds) {
                              setState(() {
                                selectedCategoryIds =
                                    selectedIds; // Update selected IDs
                              });
                            },
                          ),
                  ),
                  // SizedBox(
                  //   height: 40,
                  //   child: CustomDropdown(
                  //     value: selectedCategoryOfInterest,
                  //     items: _categories,
                  //     // hintText: 'Item Category*',
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         selectedCategoryOfInterest = newValue!;
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
                SizedBox(height: 16),
              ],

              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BasicAppButton(
                    title: isFirstStep ? "Next" : "Submit",
                    radius: 24,
                    height: 46,
                    width: MediaQuery.of(context).size.width,
                    // width: isFirstStep ? 300 : 160,
                    onPressed: () async {
                      if (isFirstStep) {
                        // Move to the second step
                        if (isBarterChecked || isDonationChecked) {
                          setState(() {
                            isFirstStep = false;
                          });
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Select Exchange Method'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('cancel'),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        if (_formKey.currentState?.validate() ?? false) {
                          String itemListedFor = getCheckboxJson();
                          String jsonAdditional = getAdditionalFieldsJson();
                          String jsonInterests =
                              getCategoriesOfInterestAsJson();

                          var finalItemData = combineJson(
                              itemListedFor, jsonAdditional, jsonInterests);

                          if (context.read<AddItemBloc>().state
                              is! AddItemLoading) {
                            context
                                .read<AddItemBloc>()
                                .add(AddItemSubmit(finalItemData));
                          }
                        }
                        // AppNavigator.pushReplacement(
                        //     context,
                        //     AddItemPhoto(
                        //       itemData: itemData,
                        //       categories: _categories,
                        //     ));
                      }
                    },
                    content: !isFirstStep ? _blockBuilder() : null,
                  ),
                  if (!isFirstStep) ...[
                    SizedBox(height: 16),
                    BasicAppButton(
                      title: "Cancel",
                      width: MediaQuery.of(context).size.width,
                      radius: 24,
                      height: 46,
                      backgroundColor: AppColors.background,
                      textColor: AppColors.primary,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Spacer(),
                  ],
                ],
              )
              // SizedBox(
              //   width: double.infinity, // Full-width button
              //   child: ElevatedButton(
              //     onPressed: () {
              //       String jsonSelectedItems = getSelectedItemsAsJson();
              //       print(jsonSelectedItems); // Print the JSON string to console
              //
              //       Navigator.pop(context); // Close the bottom sheet
              //     },
              //     child: Text('Submit'),
              //     style: ElevatedButton.styleFrom(
              //       padding: EdgeInsets.symmetric(vertical: 16),
              //       textStyle: TextStyle(fontSize: 18),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> findSubCAtegories(String newValue) async {
    _isFetchingSubCategories = true;
    List<Map<String, String>> subCategories =
        await categoryService.fetchSubCategories(newValue);
    setState(() {
      _subCategories = subCategories;
      //     [
      //   {'id': '1', 'name': 'Mountain Bike'},
      //   {'id': '2', 'name': 'Black Mamba'},
      // ];
      _isFetchingSubCategories = false;

      if (_subCategories.isNotEmpty) {
        itemSubCategory = _subCategories.first['id']!;
      }
    });
  }
}

Widget _blockBuilder() {
  return BlocListener<AddItemBloc, AddItemState>(
    listener: (context, state) {
      if (state is AddItemFailure) {
        // Show error SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
          ),
        );
      } else if (state is AddItemSuccess) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing the dialog manually
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // Navigate to AddItemPhoto page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddItemPhoto(itemId: state.itemId),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
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
  );
}

// Widget _blockBuilder() {
//   return BlocListener<AddItemBloc, AddItemState>(
//     listener: (context, state) {
//       if (state is AddItemFailure) {
//         print(state.error);
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.error),
//               backgroundColor: Colors.red,
//             ),
//           );
//         });
//       } else if (state is AddItemSuccess) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Success'),
//             content: Text(state.message),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           // showAutoDismissDialog(
//           //   context: context,
//           //   title: '',
//           //   message: state.message,
//           // );
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => AddItemPhoto(
//                   itemId: state.itemId,
//                 ),
//               ));
//
//           print("Item id...................." + state.itemId);
//           // if (state.itemId.isNotEmpty) {
//
//           Navigator.pop(context);
//         });
//       }
//     },
//     child: BlocBuilder<AddItemBloc, AddItemState>(
//       builder: (context, state) {
//         if (state is AddItemLoading) {
//           return SizedBox(
//             height: 20,
//             width: 20,
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 2,
//             ),
//           );
//         }
//
//         return Text(
//           "Create Item",
//           style: TextStyle(color: Colors.white),
//         );
//       },
//     ),
//   );
// }
