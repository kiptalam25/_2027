import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/main/pages/home.dart';

class ChooseCategories extends StatelessWidget {
  const ChooseCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: BasicAppbar(hideBack: true),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _topTitle(),
                SingleChildScrollView(
                  child: FilteredItemSelector(
                    allItems: [
                      'Apple',
                      'Banana',
                      'Orange',
                      'Grapes',
                      'Mango',
                      'Peach'
                    ],
                    onItemAdded: (selectedItems) {
                      print("Selected Items: $selectedItems");
                    },
                    onItemRemoved: (selectedItems) {
                      print("Updated Items After Removal: $selectedItems");
                    },
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: BasicAppButton(
                    onPressed: () {
                      AppNavigator.pushReplacement(context, HomePage());
                    },
                    width: double.infinity,
                    title: "Continue",
                    radius: 24,
                  ),
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
          )
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     children: [
          //       _topTitle(),
          //       SizedBox(
          //         height: 20,
          //       ),
          //       // SearchableDropdownWithApi(
          //       //   title: 'Search for items from API',
          //       //   apiUrl:
          //       //       'https://api.example.com/items', // Replace with your API URL
          //       //   onItemSelected: (selectedItems) {
          //       //     print('Selected Items: $selectedItems');
          //       //   },
          //       // ),
          //       FilteredItemSelector(
          //         allItems: [
          //           'Apple',
          //           'Banana',
          //           'Orange',
          //           'Grapes',
          //           'Mango',
          //           'Peach'
          //         ],
          //         onItemAdded: (selectedItems) {
          //           print("Selected Items: $selectedItems");
          //         },
          //         onItemRemoved: (selectedItems) {
          //           print("Updated Items After Removal: $selectedItems");
          //         },
          //         // onSkip: () {
          //         //   print("Skipped for now");
          //         // },
          //       ),
          //       Spacer(),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           ElevatedButton(
          //             onPressed: () {}, //widget.onSkip,
          //             child: Text('Skip for Now'),
          //             style: ElevatedButton.styleFrom(
          //               shape: RoundedRectangleBorder(
          //                 borderRadius:
          //                     BorderRadius.circular(30.0), // Rounded corners
          //               ),
          //             ),
          //           ),
          //           ElevatedButton(
          //             onPressed: () {
          //               AppNavigator.pushReplacement(context, HomePage());
          //             }, //widget.onContinue,
          //             child: Text('Continue'),
          //             style: ElevatedButton.styleFrom(
          //               shape: RoundedRectangleBorder(
          //                 borderRadius:
          //                     BorderRadius.circular(30.0), // Rounded corners
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
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
          Text("Select upt to 5 categories that interest you",
              style: TextStyle(fontSize: 16, color: AppColors.primary),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}

// // Searchable Dropdown that fetches data from API
// class SearchableDropdownWithApi extends StatefulWidget {
//   final String title;
//   final String apiUrl;
//   final Function(List<String>) onItemSelected;
//
//   SearchableDropdownWithApi({
//     Key? key,
//     required this.title,
//     required this.apiUrl,
//     required this.onItemSelected,
//   }) : super(key: key);
//
//   @override
//   _SearchableDropdownWithApiState createState() =>
//       _SearchableDropdownWithApiState();
// }
//
// class _SearchableDropdownWithApiState extends State<SearchableDropdownWithApi> {
//   TextEditingController _controller = TextEditingController();
//   List<String> allItems = [];
//   List<String> filteredItems = [];
//   List<String> selectedItems = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchItemsFromApi(); // Fetch data from API when the widget is initialized
//   }
//
//   Future<void> _fetchItemsFromApi() async {
//     try {
//       final response = await http.get(Uri.parse(widget.apiUrl));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           allItems = data.map((item) => item.toString()).toList();
//           filteredItems = allItems;
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load items');
//       }
//     } catch (e) {
//       print('Error fetching items: $e');
//     }
//   }
//
//   void _filterItems(String query) {
//     setState(() {
//       filteredItems = allItems
//           .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   void _addItem(String item) {
//     if (!selectedItems.contains(item)) {
//       setState(() {
//         selectedItems.add(item);
//         _controller.clear();
//         filteredItems = allItems; // Reset the filtered list
//         widget.onItemSelected(selectedItems); // Notify parent widget
//       });
//     }
//   }
//
//   void _removeItem(String item) {
//     setState(() {
//       selectedItems.remove(item);
//       widget.onItemSelected(selectedItems); // Notify parent widget
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Show loading indicator while fetching data
//         if (isLoading)
//           Center(child: CircularProgressIndicator())
//         else ...[
//           // TextField to search and filter items
//           TextField(
//             controller: _controller,
//             onChanged: _filterItems,
//             decoration: InputDecoration(
//               labelText: widget.title,
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 10),
//           // Display filtered items in a dropdown
//           if (filteredItems.isNotEmpty && _controller.text.isNotEmpty)
//             Container(
//               height: 150, // Limit the height of the dropdown
//               child: ListView.builder(
//                 itemCount: filteredItems.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(filteredItems[index]),
//                     onTap: () => _addItem(filteredItems[index]),
//                   );
//                 },
//               ),
//             ),
//           SizedBox(height: 20),
//           // Display selected items with cancel icons
//           Wrap(
//             spacing: 8.0,
//             children: selectedItems
//                 .map((item) => Chip(
//                       label: Text(item),
//                       deleteIcon: Icon(Icons.cancel),
//                       onDeleted: () => _removeItem(item),
//                     ))
//                 .toList(),
//           ),
//         ]
//       ],
//     );
//   }
// }

class FilteredItemSelector extends StatefulWidget {
  final List<String> allItems;

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
  }) : super(key: key);

  @override
  _FilteredItemSelectorState createState() => _FilteredItemSelectorState();
}

class _FilteredItemSelectorState extends State<FilteredItemSelector> {
  TextEditingController _controller = TextEditingController();
  List<String> filteredItems = [];
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.allItems; // Initialize with all available items
  }

  // Filter items based on user input
  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Add item to selected list and notify the parent
  void _addItem(String item) {
    if (!selectedItems.contains(item)) {
      setState(() {
        selectedItems.add(item);
        _controller.clear(); // Clear the input field after adding
        filteredItems = widget.allItems; // Reset the filtered list
      });
      widget.onItemAdded(selectedItems); // Notify parent widget of change
    }
  }

  // Remove item from selected list and notify the parent
  void _removeItem(String item) {
    setState(() {
      selectedItems.remove(item);
    });
    widget.onItemRemoved(selectedItems); // Notify parent widget of change
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
                return ListTile(
                  title: Text(filteredItems[index]),
                  onTap: () => _addItem(filteredItems[index]),
                );
              },
            ),
          ),
        SizedBox(height: 10),
        // Display selected items with cancel icons
        Wrap(
          spacing: 8.0,
          children: selectedItems
              .map((item) => Chip(
                    label: Text(item),
                    deleteIcon: Icon(Icons.cancel),
                    onDeleted: () => _removeItem(item),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
