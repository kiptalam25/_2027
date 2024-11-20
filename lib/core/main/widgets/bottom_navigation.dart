import 'package:flutter/material.dart';
import 'package:swapifymobile/core/main/pages/home_page.dart';
import 'package:swapifymobile/core/profile/profile_page.dart';

import '../../chat/pages/chat_page.dart';
import '../../config/themes/app_colors.dart';
import '../../onboading_flow/categories_page.dart';
import '../../onboading_flow/profile_setup.dart';

// Bottom Navigation widget
class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color backgroundColor;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
    this.selectedItemColor = AppColors.primary,
    this.unselectedItemColor = Colors.grey,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      backgroundColor: backgroundColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
    );
  }
}

// Base Page Class with BottomNavigation logic
class BasePage extends StatefulWidget {
  final int initialIndex;
  final Widget child;

  const BasePage({Key? key, required this.initialIndex, required this.child})
      : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CategoriesPage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatPage()));
        break;
      case 3:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ProfileEditPage()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Base Page')),
      body: widget.child,
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class BottomNavigation extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onItemTapped;
//   final Color selectedItemColor;
//   final Color unselectedItemColor;
//   final Color backgroundColor;
//
//   const BottomNavigation({
//     Key? key,
//     required this.currentIndex,
//     required this.onItemTapped,
//     this.selectedItemColor = Colors.blue,
//     this.unselectedItemColor = Colors.grey,
//     this.backgroundColor = Colors.white,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: onItemTapped,
//       showSelectedLabels: false,
//       showUnselectedLabels: false,
//       selectedItemColor: selectedItemColor,
//       unselectedItemColor: unselectedItemColor,
//       backgroundColor: backgroundColor,
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.other_houses),
//           label: '',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.category_rounded),
//           label: '',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.forum_rounded),
//           label: '',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: '',
//         ),
//       ],
//     );
//   }
// }
