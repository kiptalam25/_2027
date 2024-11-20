import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import '../../config/themes/app_colors.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({Key? key}) : super(key: key);

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
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
          height: screenHeight * 0.25,
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
    double screenWidth = MediaQuery.of(context).size.width;

    var imageUrls = [
      'https://via.placeholder.com/300x200.png?text=Image+1',
      'https://via.placeholder.com/300x200.png?text=Image+2',
      'https://via.placeholder.com/300x200.png?text=Image+3',
    ];
    return Scaffold(
        appBar: BasicAppbar(),
        body: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            width: double.infinity,

            // decoration: BoxDecoration(
            //   border: Border.all(
            //       color: Colors.blue,
            //       width: 2), // Set the border color and width
            //   borderRadius:
            //       BorderRadius.circular(8), // Optional: Add rounded corners
            // ),
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
                          "Product Name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Product description",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenHeight * 0.001),
                        Text(
                          "I acknowledge the contribution of the Economic Planning team for their tireless effort an commitment to ensuring the production of this document.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Product condition",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Barely Used",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: screenHeight * 0.009),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Expanded(
                            SizedBox(child: Image.asset("images/sticky.png")),
                            SizedBox(height: screenHeight * 0.02),
                            GestureDetector(
                              onTap: () {
                                // Handle click event here
                                print('Firetruck clicked!');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: const Text(
                                  "Baby things",
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Change text color as needed
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            // Expanded(
                            //     flex: 1,
                            GestureDetector(
                              onTap: () {
                                // Handle click event here
                                print('Firetruck clicked!');
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: const Text(
                                  "Kids toys",
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Change text color as needed
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            // Expanded(
                            //     flex: 1,
                            GestureDetector(
                              onTap: () {
                                // Handle click event here
                                print('Firetruck clicked!');
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: const Text(
                                  "Firetruck",
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Change text color as needed
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Poster information",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: CircleAvatar(
                                    radius:
                                        20, // Half of the diameter to achieve 100x100 size
                                    backgroundColor: AppColors.primary,
                                    child: Text(
                                      'W', // Replace with the first letter of the name
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontSize: 20, // Font size
                                        // fontWeight: FontWeight.bold, // Text weight
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Willium Johnson",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.primary),
                                    ),
                                    Text(
                                      "Swaps completed: 21",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Poster would like",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Tireless effort and commitment to .",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              "Price range",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "100Eur - 250 Eur",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FaIcon(
                                    FontAwesomeIcons
                                        .mapLocationDot, // Font Awesome Google icon
                                    color: Color(0xFF5e5e5e), // Icon color
                                  ),
                                ),
                                Text(
                                  "3km away",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            // SizedBox(height: screenHeight * 0.02),
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
          onPressed: () {},
          backgroundColor: AppColors.primary,
          title: "Make Swap Offer",
          radius: 24,
          textColor: AppColors.background,
        ),
        SizedBox(
          height: 10,
        ),
        BasicAppButton(
          onPressed: () {},
          backgroundColor: AppColors.background,
          radius: 24,
          title: "Add to Wishlist",
          textColor: AppColors.primary,
        ),
        // _continueButton(context),
        // ElevatedButton(
        //   onPressed: () {
        //     // AppNavigator.push(context, const EnterPasswordPage());
        //   },
        //   style: ElevatedButton.styleFrom(
        //     // padding: EdgeInsets.symmetric(vertical: 16),
        //     backgroundColor: Color(0xFF50644C),
        //
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        //   child: Text(
        //     'Make swap offer',
        //     style: TextStyle(fontSize: 18, color: Colors.white),
        //   ),
        // )
      ],
    );
  }

  Widget _continueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          // padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Color(0xFF50644C),
          side: BorderSide(
            color: Color(0xFF50644C), // Custom border color
            width: 1, // Border width
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white),
      child: Text(
        'Add to Wishlist',
        style: TextStyle(fontSize: 18, color: AppColors.primary),
      ),
    );
  }
}
