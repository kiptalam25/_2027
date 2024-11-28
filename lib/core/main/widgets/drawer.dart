import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/core/list_item_flow/listed_items_page.dart';
import 'package:swapifymobile/core/profile/edit_profile_page.dart';
import 'package:swapifymobile/core/welcome/splash/pages/welcome.dart';

import '../../config/themes/app_colors.dart';
import '../../onboading_flow/choose_categories.dart';

class CustomDrawer extends StatelessWidget {
  // final PageController pageController;
  // final Function(int) onPageSelected;
  // BuildContext context;
  logout(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(),
        ));
  }

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ));
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListedItemsPage(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.sticky_note_2),
                title: Text('Saved Searches'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseCategories(currentPage: 4),
                      ));
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
                  // bool loggedOut =
                  //     await isLoggedOut(); // Check if logout was successful
                  // if (loggedOut) {
                  //   print("Logged out..............................");
                  // }
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                  // );
                  Navigator.pop(context);
                  logout(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> isLoggedOut() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false; // Indicate logout failure
    }
  }
}
