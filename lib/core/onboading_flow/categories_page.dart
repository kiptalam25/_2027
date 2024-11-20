import 'package:flutter/material.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import '../config/themes/app_colors.dart';
import '../main/widgets/bottom_navigation.dart';
import '../main/widgets/drawer.dart';
import '../welcome/splash/pages/welcome.dart';
import '../widgets/search_input.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<Map<String, String>> items = [
    {
      'photoUrl': 'https://via.placeholder.com/150',
      'name': 'Item 1',
      'description': 'This is a description for Item 1.',
    },
    {
      'photoUrl': 'https://via.placeholder.com/150',
      'name': 'Item 2',
      'description': 'This is a description for Item 2.',
    },
    {
      'photoUrl': 'https://via.placeholder.com/150',
      'name': 'Item 3',
      'description': 'This is a description for Item 3.',
    },
    // Add more items as needed
  ];
  bool isCategory = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      initialIndex: 1,
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
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    AppNavigator.push(context, WelcomePage());
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
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _horizontalScroll(
                      "Recommendations", items, isCategory = false),
                  _horizontalScroll(
                      "Popular Categories", items, isCategory = true),
                  _horizontalScroll("All Categories", items, isCategory = true)
                ],
              ),
            ),
          )),
    );
  }

  Widget _horizontalScroll(
      String title, List<Map<String, String>> items, bool isCategory) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Customize the font weight
              color: Colors.black, // Set the color if needed
            ),
          ),
        ),
        SizedBox(
          height: isCategory ? 200 : 253,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.45, // Adjust the width as needed
                  margin: const EdgeInsets.only(bottom: 8, top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the card
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2, // How far the shadow spreads
                        blurRadius: 5, // How blurry the shadow is
                        offset: Offset(0, 3), // Offset to position the shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 100, // Set the minimum width as needed
                            minHeight: 120, // Set the minimum height as needed
                          ),
                          child: Image.network(
                            item['photoUrl']!,
                            height: 120, // Adjust the height as needed
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: isCategory
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          children: [
                            Text(
                              item['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Conditionally show the description
                        if (!isCategory)
                          Text(
                            item['description']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        if (!isCategory)
                          Row(
                            children: [
                              Icon(Icons.pin_drop_outlined),
                              Text("3Km"),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
