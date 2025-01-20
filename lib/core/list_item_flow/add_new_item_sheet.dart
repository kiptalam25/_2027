import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/core/list_item_flow/add_item_photo.dart';
import 'package:swapifymobile/core/list_item_flow/bloc/update_item_state.dart';
import 'package:swapifymobile/core/services/category_service.dart';

import '../onboading_flow/choose_categories.dart';
import '../usecases/item.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/notification_popup.dart';
import 'bloc/add_item_event.dart';
import 'bloc/add_item_state.dart';
import 'bloc/item_bloc.dart';
import 'bloc/update_item_bloc.dart';
import 'bloc/update_item_event.dart';
import 'package:intl/intl.dart';

class AddNewItemSheet extends StatefulWidget {
  final bool isNew;
  final dynamic item;
  //
  const AddNewItemSheet({super.key, required this.isNew, required this.item});

  @override
  _AddNewItemSheetState createState() => _AddNewItemSheetState();
}

class _AddNewItemSheetState extends State<AddNewItemSheet> {
  // pageController = this.pageController;
  late final DateTime initialDate;
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
  var estimatedDateOfPurchase = DateTime.now();

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
      'estimatedDateOfPurchase': estimatedDateOfPurchase!.toString(),
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
  late Item item;
  late String? selectedCondition = _conditions.first['id'];
  late String? selectedCategory = "";
  late String? selectedCategoryOfInterest;
  late String? itemSubCategory = "";

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    prepareUpdate();
    // _selectedDate = widget.initialDate;
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
  }

  prepareUpdate() {
    if (!widget.isNew) {
      setState(() {
        item = widget.item;
        itemNameController.text = item.title;
        descriptionController.text = item.description;
        selectedCondition = item.condition;

        if (_categories.isNotEmpty) {
          selectedCategory = item.categoryId;
        }
        selectedCategoryIds = item.swapInterests;
      });

      switch (item.exchangeMethod) {
        case 'both':
          isDonationChecked = true;
          isBarterChecked = true;
          break;
        case 'swap':
          isBarterChecked = true;
          break;
        case 'donation':
          isDonationChecked = true;
          break;
        default:
          isDonationChecked = false;
          isBarterChecked = false;
      }
    }
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

      if (_categories.isNotEmpty && !widget.isNew) {
        // selectedCondition = _conditions.first['id']!;
        selectedCategory = item.categoryId; //_categories.first['id']!;
        findSubCAtegories(selectedCategory!);

        if (_subCategories.isNotEmpty) {
          selectedCategoryOfInterest = item.subCategoryId;
        }
      } else if (_categories.isNotEmpty && widget.isNew) {
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
  bool showList = true;

  late DateTime _selectedDate =
      DateTime.now(); // For managing the selected date
  late TextEditingController _dateController; // For displaying the date

  @override
  void dispose() {
    _dateController.dispose(); // Dispose of the controller
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2100), // Latest selectable date
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });

      // Handle the update logic here (e.g., send the updated date to the backend)
      print("Updated date: ${_selectedDate.toIso8601String()}");
    }
  }

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
                  SizedBox(
                    height: 32,
                    child: Align(
                      alignment: Alignment
                          .bottomCenter, // Align the text at the bottom
                      child: Text(
                        widget.isNew ? 'List New Item' : "Edit Item",
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
                Text("Condition*"),
                SizedBox(
                  height: 10,
                ),
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
                Text("Estimated date of purchase*"),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _dateController,
                    readOnly: true, // Make the text field read-only
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context), // Open the date picker
                  ),
                  // DatePickerTextField(
                  //   // labelText: 'Start Date',
                  //
                  //   hintText: 'YYYY-MM-DD',
                  //   initialDate: estimatedDateOfPurchase,
                  //   firstDate: DateTime(2010),
                  //   lastDate: DateTime(2025),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please select a date.';
                  //     }
                  //     return null;
                  //   },
                  //   onDateSelected: (selectedDate) {
                  //     estimatedDateOfPurchase = selectedDate;
                  //     // print("Selected Start Date: $selectedDate");
                  //   },
                  // ),
                ),
                // if (isBarterChecked) ...[
                //   InputSection(
                //     label: "Price Range",
                //     hintText: "Enter price range of the item",
                //     controller: priceRange,
                //     maxCharacters: 0,
                //   ),
                // ],
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
                      child: Column(children: [
                    _categories.isEmpty
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
                                selectedCategoryIds = selectedIds;
                                showList = false;
                              });
                            },
                            onItemRemoved: (selectedIds) {
                              setState(() {
                                selectedCategoryIds = selectedIds;
                              });
                            },
                          ),
                    if (showList) ...[
                      Container(
                        height: 80,
                        child: ListView.builder(
                            itemCount: selectedCategoryIds.length,
                            itemBuilder: (context, index) {
                              final item = selectedCategoryIds[index];
                              return Row(
                                children: [
                                  Text(item),
                                ],
                              );
                            }),
                      )
                    ]
                    // if (selectedCategoryIds.isNotEmpty) ...[
                    //   Container(
                    //       child: ListView.builder(
                    //           itemCount: selectedCategoryIds.length,
                    //           itemBuilder: (context, index) {
                    //             final item = selectedCategoryIds[index];
                    //             // final isSelected = selectedItems
                    //             //     .any((selected) => selected['id'] == item['id']);
                    //
                    //             return Text(item.toString());
                    //           }))
                    // ]
                  ])),

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
                          print("Item......................................." +
                              finalItemData.toString());

                          if (widget.isNew) {
                            if (context.read<AddItemBloc>().state
                                is! AddItemLoading) {
                              context
                                  .read<AddItemBloc>()
                                  .add(AddItemSubmit(finalItemData));
                            }
                          }
                          if (!widget.isNew) {
                            print(finalItemData);
                            if (context.read<UpdateItemBloc>().state
                                is! UpdateItemLoading) {
                              context.read<UpdateItemBloc>().add(
                                  UpdateItemSubmit(finalItemData, item.id));
                            }
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
                    content: !isFirstStep && widget.isNew
                        ? _blockBuilder()
                        : !isFirstStep && !widget.isNew
                            ? _updateBlockBuilder()
                            : null,
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
        showDialog(
          context: context,
          barrierDismissible: true, // Prevent dismissing the dialog manually
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(state.error),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("...................." + state.error),
        //     backgroundColor: Colors.red,
        //   ),
        // );
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
                      builder: (context) => AddItemPhoto(
                        itemId: state.itemId,
                        action: 'new',
                      ),
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

        return Center(
          child: Text(
            "Create Item",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    ),
  );
}

Widget _updateBlockBuilder() {
  return BlocListener<UpdateItemBloc, UpdateItemState>(
    listener: (context, state) {
      if (state is UpdateItemSuccess) {
        Navigator.pop(context, 'refresh');
        StatusPopup.show(
          context,
          message: state.message,
          isSuccess: true,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddItemPhoto(
              itemId: state.itemId,
              action: 'new',
            ),
          ),
        );
      } else if (state is UpdateItemFailure) {
        StatusPopup.show(
          context,
          message: "Update Failed!",
          isSuccess: false,
        );
      }
    },
    child: BlocBuilder<UpdateItemBloc, UpdateItemState>(
      builder: (context, state) {
        if (state is UpdateItemLoading) {
          return SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        return Center(
          child: Text(
            "Update Item",
            style: TextStyle(color: Colors.white),
          ),
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
