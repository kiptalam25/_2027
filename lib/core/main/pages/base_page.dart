// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
// import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
// import 'package:swapifymobile/core/config/themes/app_colors.dart';
// import 'package:swapifymobile/core/list_item_flow/add_item_photo.dart';
// import 'package:swapifymobile/core/list_item_flow/listed_items_page.dart';
// import 'package:swapifymobile/core/main/pages/product_description.dart';
// import 'package:swapifymobile/core/list_item_flow/add_new_item_sheet.dart';
// import 'package:swapifymobile/core/main/pages/widgets/drawer.dart';
// import 'package:swapifymobile/core/onboading_flow/categories_page.dart';
// import 'package:swapifymobile/core/onboading_flow/choose.dart';
// import 'package:swapifymobile/core/onboading_flow/test.dart';
//
// import 'widgets/bottom_navigation.dart';
// import '../../welcome/pages/welcome.dart';
// import '../../widgets/search_input.dart';
// import 'home_page.dart';
//
// class BasePage extends StatefulWidget {
//   const BasePage({Key? key}) : super(key: key);
//
//   @override
//   State<BasePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<BasePage> {
//   int _currentIndex = 0;
//   bool _showSearch = true;
//
//   final PageController _pageController = PageController();
//   final TextEditingController _searchController = TextEditingController();
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//
//     _pageController.animateToPage(
//       index,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//     // _pageController
//     //     .jumpToPage(index); // Change to .animateToPage() for animation
//   }
//
//   // void _onItemTapped(int index) {
//   //   setState(() {
//   //     _currentIndex = index;
//   //   });
//   //   if (index == 0) {
//   //     AppNavigator.pushReplacement(context, HomePage());
//   //   }
//   //   if (index == 1) {
//   //     AppNavigator.pushReplacement(context, CategoriesPage());
//   //   }
//   //
//   //   print(index);
//   // }
//
//   // void _navigateToPage(int pageIndex) {
//   //   _pageController.animateToPage(
//   //     pageIndex,
//   //     duration: Duration(milliseconds: 300),
//   //     curve: Curves.easeInOut,
//   //   );
//   // }
//
//   // void _updateIndex(int index) {
//   //   setState(() {
//   //     _currentIndex = index;
//   //   });
//     // _pageController.animateToPage(
//     //   index,
//     //   duration: Duration(milliseconds: 300),
//     //   curve: Curves.easeInOut,
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: AppColors.background,
//           foregroundColor: AppColors.primary,
//           title: Row(
//             children: [
//               Expanded(child: SearchInput(controller: _searchController)),
//             ],
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.notifications),
//               onPressed: () {
//                 AppNavigator.push(context, WelcomePage());
//               },
//             ),
//             PopupMenuButton<int>(
//               icon: const Icon(Icons.more_vert),
//               onSelected: (value) {
//                 // Handle the selected value here
//                 switch (value) {
//                   case 1:
//                     print('Option 1 selected');
//                     break;
//                   case 2:
//                     print('Option 2 selected');
//                     break;
//                   case 3:
//                     print('Option 3 selected');
//                     break;
//                 }
//               },
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 1,
//                   child: Text('Option 1'),
//                 ),
//                 const PopupMenuItem(
//                   value: 2,
//                   child: Text('Option 2'),
//                 ),
//                 const PopupMenuItem(
//                   value: 3,
//                   child: Text('Option 3'),
//                 )
//               ],
//             )
//           ]),
//       drawer: CustomDrawer(
//           // onPageSelected: updateIndex,
//           ),
//       // body: BasePage(initialIndex: 0, child: _itemsGrid()),
//       body: PageView(
//         controller: _pageController,
//         onPageChanged: (index) {
//           if (index < 3) {
//             setState(() {
//               _currentIndex = index;
//               _showSearch = index == 0;
//             });
//           }
//         },
//         children: [
//           HomePage(),
//           CategoriesPage(),
//           Center(child: Text('Notifications Page')),
//           Center(child: Text('Profile Page')),
//           Center(child: Text("AddItemPhoto()")),
//           Center(child: Text("Add Item Photo")),
//           Center(child: ListedItemsPage())
//         ],
//       ),
//
//       bottomNavigationBar: BottomNavigation(
//         currentIndex: _currentIndex,
//         onItemTapped: _onItemTapped,
//         selectedItemColor:
//             AppColors.primary, // Set custom color for the selected item
//         unselectedItemColor:
//             Colors.black, // Set custom color for unselected items
//         backgroundColor: Colors.white, // Set custom background color
//       ),
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // AppNavigator.pushReplacement(context, MultiDropdownExample());
//           showModalBottomSheet(
//             context: context,
//             builder: (BuildContext context) {
//               return AddNewItemSheet(
//                   // pageController:
//                   //     _pageController
//                   ); // Custom bottom sheet widget
//             },
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//             // borderRadius: BorderRadius.zero),
//             isScrollControlled:
//                 true, // Makes the bottom sheet more flexible in height
//           );
//         },
//         foregroundColor: AppColors.background,
//         backgroundColor: AppColors.primary,
//         shape: CircleBorder(),
//         child: const Icon(Icons.add),
//       ),
//       floatingActionButtonLocation:
//           FloatingActionButtonLocation.endFloat, // Bottom-right
//     );
//   }
//
//   // Widget _
//   // Widget _itemsGrid() {
//   //   return Column(
//   //     children: [
//   //       Flexible(
//   //           // color: Colors.yellow,
//   //           child: GridView.builder(
//   //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //           crossAxisCount: 2,
//   //           crossAxisSpacing: 10,
//   //           mainAxisSpacing: 10,
//   //           childAspectRatio: 0.6,
//   //         ),
//   //         padding: EdgeInsets.all(10.0),
//   //         itemCount: items.length,
//   //         itemBuilder: (context, index) => Container(
//   //           alignment: Alignment.center,
//   //           decoration: BoxDecoration(
//   //             // color: Colors.blue,
//   //             border: Border.all(
//   //               color: Colors.grey, // Color of the border
//   //               width: 0.5, // Width of the border
//   //             ),
//   //             borderRadius: BorderRadius.circular(10.0),
//   //           ),
//   //           child: Container(
//   //             color: AppColors.background,
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //               children: [
//   //                 Padding(
//   //                   padding: const EdgeInsets.all(8.0),
//   //                   child: ClipRRect(
//   //                     borderRadius: BorderRadius.circular(10.0),
//   //                     child: SizedBox(
//   //                       height: 130.0, // Set a fixed height for the image
//   //                       width: double.infinity,
//   //                       child: Image.asset(
//   //                         "images/home_images/m2.png",
//   //                         fit: BoxFit
//   //                             .cover, // Adjust the image to cover the container
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 const Divider(
//   //                   // Line under the title
//   //                   color: AppColors.dividerColor, // Color of the line
//   //                   thickness: 1, // Thickness of the line
//   //                 ),
//   //                 const Padding(
//   //                   padding: EdgeInsets.only(left: 8.0),
//   //                   child: Text(
//   //                     "Brown Brogues",
//   //                     style: TextStyle(
//   //                         fontSize: 14,
//   //                         fontWeight: FontWeight.w700,
//   //                         color: AppColors.primary),
//   //                   ),
//   //                 ),
//   //                 // const SizedBox(
//   //                 //   height: 10,
//   //                 // ),
//   //                 Padding(
//   //                   padding: const EdgeInsets.symmetric(horizontal: 8),
//   //                   child: Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //                     children: [
//   //                       BasicAppButton(
//   //                         title: "Barter",
//   //                         width: 52,
//   //                         height: 18,
//   //                         radius: 24,
//   //                         onPressed: () {},
//   //                       ),
//   //                       const Spacer(),
//   //                       const Icon(Icons.pin_drop_outlined),
//   //                       Text(
//   //                         '3Km',
//   //                         style: TextStyle(
//   //                           color: Color(0xFF5e5e5e), // Text color
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ),
//   //                 Padding(
//   //                   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//   //                   child: InkWell(
//   //                     onTap: () {
//   //                       Navigator.push(
//   //                           context, ProductDescription() as Route<Object?>);
//   //                     },
//   //                     child: Row(
//   //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //                       children: const [
//   //                         Text("See details,"),
//   //                         Spacer(),
//   //                         Icon(Icons.arrow_forward)
//   //                       ],
//   //                     ),
//   //                   ),
//   //                 )
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       )),
//   //     ],
//   //   );
//   // }
//
//   Widget _popUpMenu() {
//     return PopupMenuButton<String>(
//         icon: Icon(Icons.menu),
//         // Hamburger icon
//         offset: Offset(0, 40),
//         // Adjust the Y value to position the menu below the icon
//         onSelected: (String result) {
//           print(result);
//         },
//         itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               const PopupMenuItem<String>(
//                 value: 'Item 1',
//                 child: Text('Item 1'),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'Item 2',
//                 child: Text('Item 2'),
//               ),
//               const PopupMenuItem<String>(
//                 value: 'Item 3',
//                 child: Text('Item 3'),
//               )
//             ]);
//   }
//   //
//   // Widget _floatingButton() {
//   //   return FloatingActionButton(
//   //     onPressed: () {
//   //       // Action when button is pressed
//   //       print('FAB Pressed!');
//   //     },
//   //     child: Icon(Icons.add),
//   //     backgroundColor: Colors.blue, // Customize color
//   //   );
//   // }
// }
