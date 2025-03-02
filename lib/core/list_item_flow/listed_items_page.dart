import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/core/list_item_flow/add_item_photo.dart';
import 'package:swapifymobile/core/list_item_flow/widgets/list_view.dart';
import 'package:swapifymobile/core/profile/profile_page.dart';
import 'package:swapifymobile/core/usecases/SingleItem.dart';
import '../../api_client/api_client.dart';
import '../services/items_service.dart';
import '../usecases/profile_data.dart';
import '../widgets/initial_circle.dart';
import '../widgets/search_input.dart';

class ListedItemsPage extends StatefulWidget {
  const ListedItemsPage({Key? key}) : super(key: key);

  @override
  State<ListedItemsPage> createState() => _ListedItemsPageState();
}

class _ListedItemsPageState extends State<ListedItemsPage> {
  // final List<String> items = List.generate(10, (index) => 'Item ${index + 1}');
  // final List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4"];
  final TextEditingController _searchController = TextEditingController();
  final ItemsService itemsService = ItemsService(ApiClient());
  late ProfileData profileData = ProfileData();

  Future<void> getProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileJson = prefs.getString('profileData');

    if (profileJson != null) {
      // Decode the JSON string back into a Map

      setState(() {
        profileData = ProfileData.fromJson(jsonDecode(profileJson));
      });
      // return jsonDecode(profileJson);
    }
    // return null;
  }

  late List<SingleItem> items = [];
  List<SingleItem> filteredItems = [];
  bool isLoading = false;
  bool isBarter = true;
  @override
  void initState() {
    getProfileData();
    fetchItems();
    filterItems("swap");
    super.initState();
  }

  void filterItems(String query) {
    setState(() {
      // Filter items where exchangeMethod is 'both' or contains the query
      filteredItems = items.where((item) {
        return item.exchangeMethod.toLowerCase() == "both" ||
            item.exchangeMethod.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // Sort the items so that those with 'both' come first
      filteredItems.sort((a, b) {
        if (a.exchangeMethod.toLowerCase() == query) {
          return -1;
        } else if (b.exchangeMethod.toLowerCase() == query) {
          return 1;
        }
        return 0; // No change in order for other items
      });
    });
  }

  void fetchItems() async {
    setState(() {
      items = [];
      isLoading = true;
    });
    String keyword = _searchController.text;
    var response = await itemsService.fetchOwnItems(keyword);
    if (response != null) {
      setState(() {
        isLoading = false;
      });
      final responseData = response.data;

      if (responseData['success'] == true) {
        setState(() {
          items = (responseData['items'] as List)
              .map((item) => SingleItem.fromJson(item))
              .toList();
          filteredItems = items;
        });
      } else {
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
    return Scaffold(
        appBar:
            AppBar(title: SearchInput(controller: _searchController), actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // AppNavigator.push(context, WelcomePage());
            },
          ),
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
              const PopupMenuItem(
                value: 2,
                child: Text('Option 2'),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text('Option 3'),
              )
            ],
          )
        ]),
        // drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              _userInfo(),
              SizedBox(
                height: 16,
              ),
              Column(
                children: [_switchBtns()],
              ),
              Expanded(
                child: items.length > 0
                    ? ReusableListView(
                        items: filteredItems,
                        onDetailsTap: (itemId) async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddItemPhoto(
                                  itemId: itemId,
                                  action: 'old',
                                ),
                              ));
                          if (result == 'refresh') {
                            setState(() {
                              fetchItems();
                            });
                          }
                        },
                      )
                    : isLoading ?  Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ):Center(child: Text("No items found"),),
                // child: Column(
                //   children: [_itemsGrid()],
                // ),
              )
              // _switchBtns(),
              // _itemsGrid(),
            ],
          ),
        ));
  }

  void handleTap(String item) {
    print("Tapped on $item"); // Handle item tap here
  }

  // Widget _itemsGrid() {
  //   return Flexible(
  //     child: SingleColumnGrid(
  //       items: items,
  //       onTap: handleTap,
  //     ),
  //   );
  // }

  Widget _switchBtns() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () {
          filterItems('swap');
          setState(() {
            isBarter = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isBarter
              ? AppColors.primary
              : AppColors.background, // Use passed background color or fallback
          minimumSize: Size(MediaQuery.of(context).size.width * .4, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10)), // Rounded corners
          ),
        ),
        child: Text(
          "Barter",
          style: TextStyle(
            color: isBarter ? AppColors.background : AppColors.primary,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          filterItems('donation');
          setState(() {
            isBarter = false;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isBarter
              ? AppColors.background
              : AppColors.primary, // Use passed background color or fallback
          minimumSize: Size(MediaQuery.of(context).size.width * .4, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10)), // Rounded corners
          ),
        ),
        child: Text(
          "Donation",
          style: TextStyle(
            color: isBarter ? AppColors.primary : AppColors.background,
          ),
        ),
      )
    ]);
  }

  Widget _userInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [

            // SizedBox(
            //   width: 16,
            // ),
            //profile

        Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200, // Fallback color
              ),
            ),
            ClipOval(
              child: Image.network(
                profileData.profilePicUrl.toString(),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return InitialCircle(
                    text: profileData.fullName.toString(), // Show initials
                    color: AppColors.primary,
                    size: 60.0,
                    textStyle: TextStyle(fontSize: 30, color: Colors.white),
                  );
                },
              ),
            ),
            // Edit icon (pen) positioned at the bottom-right
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary, // Background color of the edit icon
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    AppNavigator.pushReplacement(context, ProfileEditPage());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profileData.fullName.toString()),
                Text("Swaps completed: 21")
              ],
            )
          ],
        ),
      ],
    );
  }
}
