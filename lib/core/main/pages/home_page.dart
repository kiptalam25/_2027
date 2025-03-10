import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/auth/login/login.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/core/main/pages/filter_bottomsheet.dart';
import 'package:swapifymobile/core/onboading_flow/verification.dart';
import 'package:swapifymobile/core/profile/profile_page.dart';
import 'package:swapifymobile/core/services/items_service.dart';
import '../../../common/app_colors.dart';
import '../../list_item_flow/add_new_item_sheet.dart';
import '../../services/NetworkHelper.dart';
import '../../services/sharedpreference_service.dart';
import '../../usecases/item.dart';
import '../../usecases/location.dart';
import '../../usecases/profile_data.dart';
import '../../widgets/notification_popup.dart';
import '../../widgets/search_input.dart';
import '../item_grid.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  final bool autoClick;
  const HomePage({Key? key, required this.autoClick}) : super(key: key,);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ItemsService itemsService = ItemsService(ApiClient());

  late List<Item> items = [];
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // NetworkHelper.checkInternetAndShowPopup(context);
    if (widget.autoClick) {
      Future.delayed(Duration(milliseconds: 500), () {
        _addItem();
      });
    }
    fetchItems();
    getProfileData();
    super.initState();

  }


  late ProfileData profileData = ProfileData();
   late Location? location=null;
  Future<void> getProfileData() async {
    ProfileData? profileData1=await SharedPreferencesService.getProfileData();

    /**
     * Reason for location is so that user cannot upload item if he has not updated up profile
     *
     *
     * **/
    final location1 = profileData1?.location;
    print(profileData1?.location?.toJson().toString());
    if(location1!=null){
      location=location1;
    }else{
      location=null;
      print("Location is null");
    }
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? profileJson = prefs.getString('profileData');

    if (profileData1 != null) {
      // Decode the JSON string back into a Map

      setState(() {
        profileData = profileData1;
      });
      // return jsonDecode(profileJson);
    }
    // return null;
  }


  fetchItems() async {
    setState(() {
      items = [];
      isLoading = true;
    });

    String keyword = _searchController.text;
    var response = await itemsService.fetchItems(keyword);
    if (response != null) {
      setState(() {
        isLoading = false;
      });
      final responseData = response.data;

      if (responseData['success'] == true) {
        setState(() {
          items = (responseData['data']['items'] as List)
              .map((item) => Item.fromJson2(item))
              .toList();
        });

        // Process each item
        // for (var item in items) {
        //   print('Title: ${item.title}, Created At: ${item.createdAt}');
        // }
      } else {
        final responseBody = response.data;
        if(response.statusCode==401){
          SharedPreferencesService.clear();
          AppNavigator.pushAndRemove(context, LoginPage());
        }
        // if (responseBody is Map<String, dynamic> && responseBody.containsKey('data')) {
        //   final data = responseBody['data'];
        //   print('Data: $data');
        // }
        print('Request failed with message: ${responseData["message"]}');
      }
    } else {
      print('Service returned null');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.primary,
            title: Row(
              children: [
                Expanded(child: SearchInput(controller: _searchController)),
              ],
            ),
            actions: [
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  // Handle the selected value here
                  switch (value) {
                    case 1:
                      print('Option 1 selected');
                      break;
                    case 2:
                      print('Option 2 selected');
                      break;
                    case 3:
                      print('Option 3 selected');
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Option 1'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyPage(currentPage: 3),
                        )),
                    child: const Text('Verify'),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: const Text('Option 3'),
                  )
                ],
              ),GestureDetector(
                child: Icon(Icons.filter_list_outlined),
                onTap: () {
                  showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return FilterBottomSheet();
                  },
                );

                },

              )
            ]),
        drawer: CustomDrawer(
            // onPageSelected: updateIndex,
            ),
        body: items.isNotEmpty
            ? ItemGrid(items: items)
            : isLoading
                ? Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator()))
                : const Center(child: Text('No items available')),

        floatingActionButton: FloatingActionButton(
          onPressed: _addItem,
          foregroundColor: AppColors.background,
          backgroundColor: AppColors.primary,
          shape: CircleBorder(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // Bottom-right
      ),
    );
  }

  _addItem() async {
      /* AppNavigator.pushReplacement(context, MultiDropdownExample());
              To create an item we need users location
              so we need to check if user has updated location data
              I have checked location data on the saved profile data
             */
    await getProfileData();//Update Local profile data to ensure you have latest data
      if(location==null){

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Update Profile?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text("For You to Create an Item You need to Update Location Info"),
              actions: [
                TextButton(
                  onPressed: () {

                    Navigator.of(context).pop();
                  },
                  child: Text("No", style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {

                    Navigator.of(context).pop();
                    AppNavigator.push(context, ProfileEditPage());
                  },
                  child: Text("Yes", style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );


      }else{
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return AddNewItemSheet(isNew: true, item: null);
          },
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
          // borderRadius: BorderRadius.zero),
          isScrollControlled:
          true, // Makes the bottom sheet more flexible in height
        );
      }


  }
}
