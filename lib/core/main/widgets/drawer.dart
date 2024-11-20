import 'package:flutter/material.dart';

import '../../config/themes/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  // final PageController pageController;
  // final Function(int) onPageSelected;

  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 150,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
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
                  Navigator.pop(context);
                  // AppNavigator.pushReplacement(context, BasePage());
                  // onPageSelected(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  // AppNavigator.push(context, HorizontalScrollPage());
                  Navigator.pop(context);
                  // onPageSelected(2);
                },
              ),
              ListTile(
                leading: Icon(Icons.heart_broken),
                title: Text('Saved Items'),
                onTap: () {
                  Navigator.pop(context);
                  // onPageSelected(6);
                },
              ),
              ListTile(
                leading: Icon(Icons.sticky_note_2),
                title: Text('Saved Searches'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // onPageSelected(1);
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
                title: Text('Help and Support'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Navigate to help or perform an action
                },
              ),
              ListTile(
                leading: Icon(Icons.report),
                title: Text('Report a problem'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to report a problem or perform an action
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
      ),
    );
  }
}
