import 'package:flutter/material.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';

import '../../common/helper/navigator/app_navigator.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../../common/widgets/button/basic_app_button.dart';
import '../../main/pages/home.dart';
import '../../presentation/pages/choose_categories.dart';
import '../config/themes/app_colors.dart';

class ChooseCategories extends StatefulWidget {
  // const ChooseCategories({super.key});
  final int currentPage;
  ChooseCategories({required this.currentPage});

  @override
  State<ChooseCategories> createState() => _ChooseCategoriesState();
}

class _ChooseCategoriesState extends State<ChooseCategories> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: BasicAppbar(
              title: PageIndicator(currentPage: widget.currentPage),
              hideBack: true),
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
        children: const [
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
