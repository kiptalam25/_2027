import 'package:flutter/material.dart';

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
    this.selectedItemColor = Colors.blue,
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
          icon: Icon(Icons.other_houses),
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

// // Main app to demonstrate the reusable widget
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     Center(child: Text('Home Page')),
//     Center(child: Text('Search Page')),
//     Center(child: Text('Profile Page')),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reusable Bottom Navigation Example'),
//       ),
//       body: _pages[_currentIndex],
//       bottomNavigationBar: CustomBottomNavigation(
//         currentIndex: _currentIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }
//
// void main() => runApp(MyApp());
