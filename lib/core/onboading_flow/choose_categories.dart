import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/api_constants/api_constants.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/core/profile/profile_bloc.dart';
import 'package:swapifymobile/core/services/profile_service.dart';
import 'package:swapifymobile/core/services/registration_service.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/popup.dart';
import '../../api_client/api_client.dart';
import '../../common/widgets/navigation/app_navigator.dart';
import '../main/pages/home_page.dart';

class ChooseCategories extends StatefulWidget {
  final int currentPage;
  const ChooseCategories({super.key, required this.currentPage});

  @override
  State<ChooseCategories> createState() => _ChooseCategoriesState();
}

class _ChooseCategoriesState extends State<ChooseCategories> {
  bool isUpdating = false;
  bool isComplete = false;
  bool isFetchingCategories = false;
  final RegistrationService registrationService =
      RegistrationService(new ApiClient());
  List<Map<String, String>> items = [];
  List<String> selectedItemIds = []; // To store selected item IDs

  @override
  void initState() {
    super.initState();
    fetchItemsFromApi();
  }

  // Future<RegisterUser?> getUserData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userData = prefs.getString('registerUser'); // Get JSON string
  //   if (userData != null) {
  //     Map<String, dynamic> userMap = jsonDecode(userData); // Decode JSON to map
  //     return RegisterUser.fromJson(userMap); // Convert map to RegisterUser
  //   }
  //   return null; // Return null if no data found
  // }

  // Future<UserProfile?> assembleProfile() async {
  //   RegisterUser? user = await getUserData();
  //
  //   if (user != null) {
  //     UserProfile userProfile = UserProfile(
  //       fullName: user.fullName,
  //       profilePicUrls: [
  //         "https://example.com/pic1.jpg",
  //         "https://example.com/pic2.jpg"
  //       ],
  //       bio: user.bio,
  //       location: Location(
  //         country: "United States",
  //         city: "San Francisco",
  //       ),
  //       interests: Interests(
  //         subCategoryId: selectedItemIds, // Use selected item IDs here
  //         city: ["New York", "Los Angeles"],
  //       ),
  //     );
  //     return userProfile;
  //
  //     // Now you can use userProfile, e.g., post it to an API
  //   } else {
  //     print("No user data found in SharedPreferences.");
  //     return null;
  //   }
  // }
  Future<Map<String, dynamic>> getSwapCategoriesAsJson() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final Map<String, dynamic> jsonMap = {
      "categories": selectedItemIds,
      "userId": sharedPreferences.get("userId")
    };
    return jsonMap;
  }

  Future<void> updateSwapInterests(BuildContext context) async {
    try {
      setState(() {
        isUpdating = true;
      });
      var payload = await getSwapCategoriesAsJson();
      print(jsonEncode(payload));
      final response = await registrationService.updateSwapInterests(payload);
      if (response.success) {
        setState(() {
          isUpdating = false;
        });
        showCustomModalBottomSheet(context);
      } else {
        setState(() {
          isUpdating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.success}   ${response.message}')),
        );
      }
    } catch (e) {
      isUpdating = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e}')),
      );
    }
  }

  Future<void> fetchItemsFromApi() async {
    isFetchingCategories = true;
    try {
      final response = await Dio().get(ApiConstants.categories);
      if (response.statusCode == 200) {
        isFetchingCategories = false;
        setState(() {
          items = response.data
              .map<Map<String, String>>((item) => {
                    'id': item['_id'].toString(),
                    'name': item['name'].toString(),
                  })
              .toList();
        });
      }
    } catch (e) {
      print('Failed to load items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => ProfileBloc(ProfileService(ApiClient())),
        child: Scaffold(
            appBar: BasicAppbar(
                title: PageIndicator(currentPage: widget.currentPage),
                hideBack: true),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isFetchingCategories
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        _topTitle(),
                        SingleChildScrollView(
                          child: items.isEmpty
                              ? Center(child: CircularProgressIndicator())
                              : FilteredItemSelector(
                                  returnType: "id",
                                  allItems: items,
                                  onItemAdded: (selectedIds) {
                                    setState(() {
                                      selectedItemIds =
                                          selectedIds; // Update selected IDs
                                    });
                                  },
                                  onItemRemoved: (selectedIds) {
                                    setState(() {
                                      selectedItemIds =
                                          selectedIds; // Update selected IDs
                                    });
                                  },
                                ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: BasicAppButton(
                              title: "Continue",
                              width: double.infinity,
                              radius: 24,
                              content: isUpdating
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : Text(
                                      "Continue",
                                      style: TextStyle(
                                          color: AppColors.background),
                                    ),
                              onPressed: isUpdating
                                  ? null
                                  : () async {
                                      updateSwapInterests(context);
                                    }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppNavigator.pushReplacement(context, HomePage());
                          },
                          child: Text("Skip for now",
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
            )),
      ),
    );
  }

  Widget _topTitle() {
    return Center(
      child: Column(
        children: [
          Text("Choose Swap Categories",
              style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          Text("Select up to 5 categories that interest you",
              style: TextStyle(fontSize: 16, color: AppColors.primary),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}

class FilteredItemSelector extends StatefulWidget {
  final List<Map<String, String>> allItems;
  final String returnType;
  final Function(List<String>) onItemAdded;
  final Function(List<String>) onItemRemoved;
  final String labelText;
  final String hintText;

  const FilteredItemSelector({
    Key? key,
    required this.allItems,
    required this.onItemAdded,
    required this.onItemRemoved,
    this.labelText = 'Choose Categories',
    this.hintText = 'Type to choose...',
    required this.returnType,
  }) : super(key: key);

  @override
  _FilteredItemSelectorState createState() => _FilteredItemSelectorState();
}

class _FilteredItemSelectorState extends State<FilteredItemSelector> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> filteredItems = [];
  List<Map<String, String>> selectedItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.allItems; // Initialize with all available items
  }

  // Filter items based on user input
  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.allItems
          .where((item) =>
              item['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Add item to selected list and notify the parent with IDs
  void _addItem(Map<String, String> item) {
    if (!selectedItems.any((selected) => selected['id'] == item['id'])) {
      setState(() {
        selectedItems.add(item);
        _controller.clear(); // Clear the input field after adding
        filteredItems = widget.allItems; // Reset the filtered list
      });
      widget.onItemAdded(selectedItems
          .map((item) =>
              widget.returnType == "name" ? item['name']! : item['id']!)
          .toList()); // Notify parent of selected IDs
    }
  }

  // Remove item from selected list and notify the parent with IDs
  void _removeItem(Map<String, String> item) {
    setState(() {
      selectedItems.removeWhere((selected) => selected['id'] == item['id']);
    });
    widget.onItemRemoved(selectedItems
        .map(
            (item) => widget.returnType == "name" ? item['name']! : item['id']!)
        .toList()); // Notify parent of selected IDs
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextField with rounded borders
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _controller,
          onChanged: _filterItems,
          decoration: InputDecoration(
            labelText: 'Search Items',
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0), // Rounded corners
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0), // Rounded corners
              borderSide: BorderSide(color: AppColors.textBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0), // Rounded corners
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 10),
        // Display filtered items in a dropdown
        if (filteredItems.isNotEmpty && _controller.text.isNotEmpty)
          Container(
            height: 150, // Limit the height of the dropdown
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(10.0), // Rounded corners for dropdown
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final isSelected = selectedItems
                    .any((selected) => selected['id'] == item['id']);

                return ListTile(
                  title: Text(item['name']!),
                  trailing: isSelected
                      ? IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _removeItem(item),
                        )
                      : IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _addItem(item),
                        ),
                );
              },
            ),
          ),
        SizedBox(height: 10),
        // Display selected items with cancel icons
        Wrap(
          children: selectedItems
              .map((item) => Chip(
                    label: Text(item['name']!),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () => _removeItem(item),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

//
// class ChooseCategories extends StatefulWidget {
//   final int currentPage;
//   const ChooseCategories({super.key, required this.currentPage});
//
//   @override
//   State<ChooseCategories> createState() => _ChooseCategoriesState();
// }
//
// class _ChooseCategoriesState extends State<ChooseCategories> {
//   List<Map<String, String>> items = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchItemsFromApi();
//   }
//
//   Future<RegisterUser?> getUserData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userData = prefs.getString('registerUser'); // Get JSON string
//     if (userData != null) {
//       Map<String, dynamic> userMap = jsonDecode(userData); // Decode JSON to map
//       return RegisterUser.fromJson(userMap); // Convert map to RegisterUser
//     }
//     return null; // Return null if no data found
//   }
//
//   Future<void> createProfile() async {
//     RegisterUser? user = await getUserData();
//
//     if (user != null) {
//       UserProfile userProfile = UserProfile(
//         fullName: user.fullName,
//         profilePicUrls: [
//           "https://example.com/pic1.jpg",
//           "https://example.com/pic2.jpg"
//         ],
//         bio: user.bio,
//         location: Location(
//           country: "United States",
//           city: "San Francisco",
//         ),
//         interests: Interests(
//           subCategoryId: [
//             "60d5ecb8b6e7c82b3c9f4d7a",
//             "60d5ecb8b6e7c82b3c9f4d7b"
//           ],
//           city: ["New York", "Los Angeles"],
//         ),
//       );
//
//       // Now you can use userProfile, e.g., post it to an API
//     } else {
//       print("No user data found in SharedPreferences.");
//     }
//   }
//
//   Future<void> fetchItemsFromApi() async {
//     try {
//       final response = await Dio().get(ApiConstants.categories);
//       if (response.statusCode == 200) {
//         setState(() {
//           items = response.data
//               .map<Map<String, String>>((item) => {
//                     'id': item['_id'].toString(),
//                     'name': item['name'].toString(),
//                   })
//               .toList();
//         });
//       }
//     } catch (e) {
//       print('Failed to load items: $e');
//     }
//   }
//
//   void onItemSelected(String id) {
//     print("Selected Item ID: $id");
//   }
//
//   // const ChooseCategories({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: BasicAppbar(
//               title: PageIndicator(currentPage: widget.currentPage),
//               hideBack: true),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 _topTitle(),
//                 SingleChildScrollView(
//                   child: items.isEmpty
//                       ? Center(child: CircularProgressIndicator())
//                       : FilteredItemSelector(
//                           allItems: items,
//                           onItemAdded: (selectedItems) {
//                             print("Selected Items: $selectedItems");
//                           },
//                           onItemRemoved: (selectedItems) {
//                             print(
//                                 "Updated Items After Removal: $selectedItems");
//                           },
//                         ),
//                 ),
//                 Spacer(),
//                 SizedBox(
//                   width: double.infinity,
//                   child: BasicAppButton(
//                     onPressed: () {
//                       showCustomModalBottomSheet(context);
//                       // AppNavigator.pushReplacement(context, HomePage());
//                     },
//                     width: double.infinity,
//                     title: "Continue",
//                     radius: 24,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     AppNavigator.pushReplacement(context, HomePage());
//                   },
//                   child: Text("Skip for now",
//                       style: TextStyle(fontWeight: FontWeight.w700)),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 )
//               ],
//             ),
//           )),
//     );
//   }
//
//   Widget _topTitle() {
//     return Center(
//       child: Column(
//         children: [
//           Text("Choose Swap Categories",
//               style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
//           SizedBox(
//             height: 20,
//           ),
//           Text("Select upt to 5 categories that interest you",
//               style: TextStyle(fontSize: 16, color: AppColors.primary),
//               textAlign: TextAlign.center)
//         ],
//       ),
//     );
//   }
// }
//
// class FilteredItemSelector extends StatefulWidget {
//   final List<Map<String, String>>
//       allItems; // Updated to accept list of maps with 'id' and 'name'
//   final Function(List<String>) onItemAdded;
//   final Function(List<String>) onItemRemoved;
//   final String labelText;
//   final String hintText;
//
//   const FilteredItemSelector({
//     Key? key,
//     required this.allItems,
//     required this.onItemAdded,
//     required this.onItemRemoved,
//     this.labelText = 'Choose Categories',
//     this.hintText = 'Type to choose...',
//   }) : super(key: key);
//
//   @override
//   _FilteredItemSelectorState createState() => _FilteredItemSelectorState();
// }
//
// class _FilteredItemSelectorState extends State<FilteredItemSelector> {
//   TextEditingController _controller = TextEditingController();
//   List<Map<String, String>> filteredItems = [];
//   List<Map<String, String>> selectedItems = [];
//
//   @override
//   void initState() {
//     super.initState();
//     filteredItems = widget.allItems; // Initialize with all available items
//   }
//
//   // Filter items based on user input
//   void _filterItems(String query) {
//     setState(() {
//       filteredItems = widget.allItems
//           .where((item) =>
//               item['name']!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   // Add item to selected list and notify the parent with IDs
//   void _addItem(Map<String, String> item) {
//     if (!selectedItems.any((selected) => selected['id'] == item['id'])) {
//       setState(() {
//         selectedItems.add(item);
//         _controller.clear(); // Clear the input field after adding
//         filteredItems = widget.allItems; // Reset the filtered list
//       });
//       widget.onItemAdded(selectedItems
//           .map((item) => item['id']!)
//           .toList()); // Notify parent of selected IDs
//     }
//   }
//
//   // Remove item from selected list and notify the parent with IDs
//   void _removeItem(Map<String, String> item) {
//     setState(() {
//       selectedItems.removeWhere((selected) => selected['id'] == item['id']);
//     });
//     widget.onItemRemoved(selectedItems
//         .map((item) => item['id']!)
//         .toList()); // Notify parent of selected IDs
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // TextField with rounded borders
//         SizedBox(
//           height: 10,
//         ),
//         TextField(
//           controller: _controller,
//           onChanged: _filterItems,
//           decoration: InputDecoration(
//             labelText: 'Search Items',
//             labelStyle: TextStyle(color: Colors.grey),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(24.0), // Rounded corners
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(24.0), // Rounded corners
//               borderSide: BorderSide(color: AppColors.textBorder),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(24.0), // Rounded corners
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//           ),
//         ),
//         SizedBox(height: 10),
//         // Display filtered items in a dropdown
//         if (filteredItems.isNotEmpty && _controller.text.isNotEmpty)
//           Container(
//             height: 150, // Limit the height of the dropdown
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius:
//                   BorderRadius.circular(10.0), // Rounded corners for dropdown
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3), // changes position of shadow
//                 ),
//               ],
//             ),
//             child: ListView.builder(
//               itemCount: filteredItems.length,
//               itemBuilder: (context, index) {
//                 final item = filteredItems[index];
//                 final isSelected = selectedItems
//                     .any((selected) => selected['id'] == item['id']);
//
//                 return ListTile(
//                   title: Text(item['name']!),
//                   trailing: isSelected
//                       ? IconButton(
//                           icon: Icon(Icons.remove),
//                           onPressed: () => _removeItem(item),
//                         )
//                       : IconButton(
//                           icon: Icon(Icons.add),
//                           onPressed: () => _addItem(item),
//                         ),
//                 );
//               },
//             ),
//           ),
//         SizedBox(height: 10),
//         // Display selected items with cancel icons
//         Wrap(
//           children: selectedItems
//               .map((item) => Chip(
//                     label: Text(item['name']!),
//                     deleteIcon: Icon(Icons.close),
//                     onDeleted: () => _removeItem(item),
//                   ))
//               .toList(),
//         ),
//       ],
//     );
//   }
// }
