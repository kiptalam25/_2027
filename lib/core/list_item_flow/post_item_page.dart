import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/app_bar.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/core/list_item_flow/listed_items_page.dart';
import '../../common/widgets/app_navigator.dart';
import '../../common/app_colors.dart';

class PostItemPage extends StatefulWidget {
  const PostItemPage({Key? key}) : super(key: key);

  @override
  State<PostItemPage> createState() => _PostItemPageState();
}

class _PostItemPageState extends State<PostItemPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _images = [
    'https://via.placeholder.com/300x200.png?text=Image+1',
    'https://via.placeholder.com/300x200.png?text=Image+2',
    'https://via.placeholder.com/300x200.png?text=Image+3',
    'https://via.placeholder.com/300x200.png?text=Image+4',
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _imagesDisplay() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.30,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  _images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 8 : 6,
              height: _currentPage == index ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? AppColors.primary : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: BasicAppbar(
          hideBack: true,
          title: Text("List Item"),
        ),
        body: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _imagesDisplay(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nike Fiesta",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "Item listed for: ",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                border: Border(),
                                color: AppColors.smallBtnBackground,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Text(
                                "Barter",
                                style: TextStyle(
                                  color: AppColors
                                      .primary, // Change text color as needed
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Item Information",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Nike Fiestas that have only been worn once I am looking to swap because they are a slightly bigger size than what I usually wear",
                          style: TextStyle(),
                        ),
                        SizedBox(height: screenHeight * 0.009),
                        SizedBox(height: screenHeight * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Item Condition",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Barel Worn")
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Item Category",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Men’s Fashion, Footwear, Sports",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              "Categories of interest",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Men’s Fashion, Home Appliances, Kitchen Utensils",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _addToWishlistBtn(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        )));
  }

  Widget _addToWishlistBtn() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BasicAppButton(
          title: "List item",
          radius: 24,
          onPressed: () {
            AppNavigator.push(context, ListedItemsPage());
          },
        ),
        SizedBox(
          height: 16,
        ),
        _continueButton(context),
      ],
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      title: "Save as draft",
      radius: 24,
      backgroundColor: AppColors.background,
      textColor: AppColors.primary,
      onPressed: () {},
    );
  }
}
