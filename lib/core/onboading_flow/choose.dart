import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/api_constants/api_constants.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/onboading_flow/services/registration_service.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';

import '../../api_client/api_client.dart';
import '../../common/helper/navigator/app_navigator.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../../common/widgets/button/basic_app_button.dart';
import '../main/pages/base_page.dart';
import '../main/pages/home_page.dart';
import 'choose_categories.dart';
import '../config/themes/app_colors.dart';

class ChooseCategories extends StatefulWidget {
  // const ChooseCategories({super.key});
  final int currentPage;
  ChooseCategories({required this.currentPage});

  @override
  State<ChooseCategories> createState() => _ChooseCategoriesState();
}

class _ChooseCategoriesState extends State<ChooseCategories> {
  List<Map<String, String>> items = [];
  final RegistrationService _regService = RegistrationService(ApiClient());

  @override
  void initState() {
    super.initState();
    fetchItemsFromApi();
  }

  Future<RegisterUser?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('registerUser'); // Get JSON string
    if (userData != null) {
      Map<String, dynamic> userMap = jsonDecode(userData); // Decode JSON to map
      return RegisterUser.fromJson(userMap); // Convert map to RegisterUser
    }
    return null; // Return null if no data found
  }

  Future<void> fetchItemsFromApi() async {
    final response = await _regService.fetchItemsFromApi();

    setState(() {
      items = response;
    });
    // try {
    //   final response = await Dio().get(ApiConstants.categories);
    //   if (response.statusCode == 200) {
    //     setState(() {
    //       items = response.data
    //           .map<Map<String, String>>((item) => {
    //                 'id': item['_id'].toString(),
    //                 'name': item['name'].toString(),
    //               })
    //           .toList();
    //     });
    //   }
    // } catch (e) {
    //   print('Failed to load items: $e');
    // }
  }

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
                    allItems: items,
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
                  height: 46,
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
          )),
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
