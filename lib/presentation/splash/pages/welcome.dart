import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/common/widgets/button/basic_app_button.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/main/pages/home.dart';
import 'package:swapifymobile/presentation/splash/pages/widgets/ImageCarousel.dart';

import '../../pages/choose_categories.dart';
import '../../pages/registration.dart';
import '../../pages/widgets/privacy_pop_up.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  // void _showPrivacyPopup(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => DraggableScrollableSheet(
  //       initialChildSize: 0.5,
  //       maxChildSize: 0.8,
  //       minChildSize: 0.3,
  //       expand: false,
  //       builder: (BuildContext context, ScrollController scrollController) {
  //         return PrivacyPolicyPopup(
  //           onCancel: () {
  //             Navigator.pop(context); // Close the popup on Cancel
  //           },
  //           onContinue: () {
  //             Navigator.pop(context); // Close the popup and show a message
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text('You accepted the Privacy Policy'),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  void _showPrivacyPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: 20), // Controls the horizontal padding
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.5, // Half of the screen height
            padding: const EdgeInsets.all(16.0),
            child: PrivacyPolicyPopup(
              onCancel: () {
                Navigator.pop(context); // Close the dialog on Cancel
              },
              onContinue: () {
                Navigator.pop(context); // Close the dialog and show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You accepted the Privacy Policy'),
                  ),
                );
                AppNavigator.pushReplacement(context, Registration());
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final List<String> imageUrls = [
      'https://via.placeholder.com/300x200.png?text=Image+1',
      'https://via.placeholder.com/300x200.png?text=Image+2',
      'https://via.placeholder.com/300x200.png?text=Image+3',
    ];

    double topSize = 20;

    return Scaffold(
        appBar: BasicAppbar(hideBack: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: 80,),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Welcome to Swapify",
                      style: TextStyle(
                        fontSize: 24,
                        // color: Colors.black,
                      )),
                ),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Trade your items, save money, and connect\n with your community.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          // color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ItemDetailsPage(
                        imageUrls: [
                          'https://example.com/image1.jpg',
                          'https://example.com/image2.jpg',
                          'https://example.com/image3.jpg',
                        ],
                        description: '',
                      ),
                      // child: Image.asset(
                      //   'images/welcome.png', // Ensure the image is in the assets folder
                      //   // height: screenHeight * 0.5,
                      //   // width: screenWidth * 0.9,
                      // ),
                    ),
                    SizedBox(height: 20),
                    BasicAppButton(
                      title: "Login",
                      radius: 24,
                      backgroundColor: AppColors.background,
                      textColor: AppColors.primary,
                      onPressed: () {},
                    )
                    // SizedBox(
                    //   width: screenWidth * 1,
                    //   height: screenHeight * 0.05, // Set the desired width
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       AppNavigator.pushReplacement(context, HomePage());
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors
                    //           .white, //Color(0xFF50644C),// Custom button background color
                    //       side: BorderSide(
                    //         color: Color(0xFF50644C), // Custom border color
                    //         width: 2, // Border width
                    //       ),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(
                    //             12), // Custom border radius
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Login',
                    //       style: TextStyle(color: Color(0xFF50644C)),
                    //     ),
                    //   ),
                    // ),
                    ,
                    SizedBox(height: 20),
                    BasicAppButton(
                      onPressed: () {
                        _showPrivacyPopup(context);
                      },
                      radius: 24,
                      title: "Sign Up",
                    )
                  ],
                  //
                ),
              ],
            ),
          ),
        ));
  }
}

class ItemDetailsPage extends StatelessWidget {
  final List<String> imageUrls;
  final String description;

  ItemDetailsPage({required this.imageUrls, required this.description});

  // double screenHeight = MediaQuery.of(g).size.height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Carousel for item photos
          CarouselSlider(
            options: CarouselOptions(
              height: 350, //screenHeight * 0.5,
              //   // width: screenWidth * 0.9,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: true,
              // aspectRatio: 16 / 9,
              // viewportFraction: 0.8,
            ),
            items: imageUrls.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // Description at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
