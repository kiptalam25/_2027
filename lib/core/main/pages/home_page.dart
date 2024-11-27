import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/core/main/pages/product_description.dart';
import 'package:swapifymobile/core/services/items_service.dart';
import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widgets/button/basic_app_button.dart';
import '../../config/themes/app_colors.dart';
import '../../list_item_flow/add_new_item_sheet.dart';
import '../../usecases/item.dart';
import '../../welcome/splash/pages/welcome.dart';
import '../../widgets/search_input.dart';
import '../item_grid.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ItemsService itemsService = ItemsService(ApiClient());

  // final List<String> items = List.generate(10, (index) => 'Item ${index + 1}');
  late List<Item> items = [];
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    fetchItems();
    super.initState();
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
              .map((item) => Item.fromJson(item))
              .toList();
        });

        // Process each item
        // for (var item in items) {
        //   print('Title: ${item.title}, Created At: ${item.createdAt}');
        // }
      } else {
        print('Request failed with message: ${responseData["message"]}');
      }
    } else {
      print('Service returned null');
      setState(() {
        isLoading = false;
      });
    }
    //
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Items Fetched successfully'),
    //     ),
    //   );
    // }
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
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  fetchItems();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => WelcomePage(),
                  //     ));
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

        // Column(
        //   children: [
        //     Flexible(
        //         child: GridView.builder(
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //         crossAxisSpacing: 10,
        //         mainAxisSpacing: 10,
        //         childAspectRatio: 0.6,
        //       ),
        //       padding: EdgeInsets.all(10.0),
        //       itemCount: items?.length,
        //       itemBuilder: (context, index) => Container(
        //         alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           color: Colors.white, // Background color of the card
        //           borderRadius: BorderRadius.circular(12.0), // Rounded corners
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.grey.withOpacity(0.5), // Shadow color
        //               spreadRadius: 2, // How far the shadow spreads
        //               blurRadius: 5, // How blurry the shadow is
        //               offset: Offset(0, 3), // Offset to position the shadow
        //             ),
        //           ],
        //         ),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(10.0),
        //                 child: SizedBox(
        //                   height: 130.0, // Set a fixed height for the image
        //                   width: double.infinity,
        //                   child: Image.asset(
        //                     "images/home_images/m2.png",
        //                     fit: BoxFit
        //                         .cover, // Adjust the image to cover the container
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: const Divider(
        //                 // Line under the title
        //                 color: AppColors.dividerColor, // Color of the line
        //                 thickness: 2, // Thickness of the line
        //               ),
        //             ),
        //             const Padding(
        //               padding: EdgeInsets.only(left: 8.0),
        //               child: Text(
        //                 "Brown Brogues",
        //                 style: TextStyle(
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.w700,
        //                     color: AppColors.primary),
        //               ),
        //             ),
        //             // const SizedBox(
        //             //   height: 10,
        //             // ),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 8),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                 children: [
        //                   BasicAppButton(
        //                     title: "Barter",
        //                     width: 52,
        //                     height: 18,
        //                     radius: 24,
        //                     onPressed: () {},
        //                   ),
        //                   const Spacer(),
        //                   const Icon(
        //                     Icons.pin_drop_outlined,
        //                     size: 16,
        //                   ),
        //                   Text(
        //                     '3Km',
        //                     style: TextStyle(
        //                       color: Color(0xFF5e5e5e), // Text color
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        //               child: InkWell(
        //                 onTap: () {
        //                   Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => ProductDescription(),
        //                       ));
        //                 },
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: const [
        //                     Text("See details"),
        //                     Spacer(),
        //                     Icon(
        //                       Icons.arrow_forward,
        //                       size: 16,
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     )),
        //   ],
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // AppNavigator.pushReplacement(context, MultiDropdownExample());
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return AddNewItemSheet(
                    // pageController:
                    //     _pageController
                    ); // Custom bottom sheet widget
              },
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              // borderRadius: BorderRadius.zero),
              isScrollControlled:
                  true, // Makes the bottom sheet more flexible in height
            );
          },
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
}
