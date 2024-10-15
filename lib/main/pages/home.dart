import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/main/pages/product_description.dart';
import 'package:swapifymobile/main/pages/widgets/add_new_item_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> items = List.generate(10, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary,
          title: Container(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your action here
              },
            ),
            PopupMenuButton<int>(
              icon: Icon(Icons.more_vert),
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
      drawer: _drawer(),
      body: Column(
        children: [
          Flexible(
              // color: Colors.yellow,
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            padding: EdgeInsets.all(10.0),
            itemCount: items.length,
            itemBuilder: (context, index) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // color: Colors.blue,
                border: Border.all(
                  color: Colors.grey, // Color of the border
                  width: 0.5, // Width of the border
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        height: 150.0, // Set a fixed height for the image
                        width: double.infinity,
                        child: Image.asset(
                          "images/img1.png",
                          fit: BoxFit
                              .cover, // Adjust the image to cover the container
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    // Line under the title
                    color: AppColors.dividerColor, // Color of the line
                    thickness: 1, // Thickness of the line
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "2-seater Sofa",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BasicAppButton(
                          title: "Barter",
                          width: 52,
                          height: 18,
                          radius: 24,
                          onPressed: () {},
                        ),
                        Spacer(),
                        Icon(Icons.pin_drop_outlined),
                        Text(
                          '3Km',
                          style: TextStyle(
                            color: Color(0xFF5e5e5e), // Text color
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("See details,"),
                        Spacer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return AddNewItemSheet(); // Custom bottom sheet widget
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled:
                true, // Makes the bottom sheet more flexible in height
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Bottom-right
    );
  }

  Widget _popUpMenu() {
    return PopupMenuButton<String>(
        icon: Icon(Icons.menu),
        // Hamburger icon
        offset: Offset(0, 40),
        // Adjust the Y value to position the menu below the icon
        onSelected: (String result) {
          print(result);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Item 1',
                child: Text('Item 1'),
              ),
              const PopupMenuItem<String>(
                value: 'Item 2',
                child: Text('Item 2'),
              ),
              const PopupMenuItem<String>(
                value: 'Item 3',
                child: Text('Item 3'),
              )
            ]);
  }
  //
  // Widget _floatingButton() {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       // Action when button is pressed
  //       print('FAB Pressed!');
  //     },
  //     child: Icon(Icons.add),
  //     backgroundColor: Colors.blue, // Customize color
  //   );
  // }

  Widget _drawer() {
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Stack(
              children: [
                const SizedBox(
                  height: 150,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        // color: AppColors.primary,
                        ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Swapify',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 20,
                  child: IconButton(
                    icon: Icon(Icons.close, color: AppColors.primary),
                    onPressed: () {
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to home or perform an action
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to settings or perform an action
              },
            ),
            ListTile(
              leading: Icon(Icons.heart_broken),
              title: Text('Saved Items'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to settings or perform an action
              },
            ),
            ListTile(
              leading: Icon(Icons.sticky_note_2),
              title: Text('Saved Searches'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to settings or perform an action
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to settings or perform an action
              },
            ),
          ],
        ),
        Column(
          children: [
            Divider(),
            ListTile(
              leading: Icon(Icons.help),
              title: const Text('Help and Support'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to help or perform an action
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Report a problem'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to help or perform an action
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Perform logout action
              },
            ),
          ],
        ),
      ],
    ));
  }
}
