import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/common/widgets/app_bar.dart';
import 'package:swapifymobile/common/widgets/basic_app_button.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/core/main/pages/home_page.dart';
import '../../../../auth/login/login.dart';
import '../../../onboading_flow/onboarding_flow.dart';
import '../../widgets/privacy_pop_up.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // void _showPrivacyPopup(BuildContext context) {
  @override
  void initState() {
    checkIfLoggedIn(context);
    super.initState();
  }

  checkIfLoggedIn(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = await sharedPreferences.getString("token");
    if (token!.isNotEmpty) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    }
  }

  void _showPrivacyPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: 20), // Controls the horizontal padding
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.7, // Half of the screen height
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardFlow(),
                    ));
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: BasicAppbar(hideBack: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Welcome to Swapify",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Trade your items, save money, and connect\n with your community.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 16),
                        ItemDetailsPage(
                          items: [
                            {
                              'image': 'images/welcome_images/Frame.png',
                              'description':
                                  'List items for Barter or Donation...or both',
                            },
                            {
                              'image': 'images/welcome_images/Frame1.png',
                              'description':
                                  'Get recommendations using our Smart Matching Algorithm',
                            },
                            {
                              'image': 'images/welcome_images/Frame2.png',
                              'description':
                                  'or simply browse through the catalogue of listed items',
                            },
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        BasicAppButton(
                          height: 46,
                          onPressed: () {
                            _showPrivacyPopup(context);
                          },
                          radius: 24,
                          title: "Sign Up",
                        ),
                        SizedBox(height: 16),
                        BasicAppButton(
                          title: "Login",
                          height: 46,
                          radius: 24,
                          backgroundColor: AppColors.background,
                          textColor: AppColors.primary,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ItemDetailsPage extends StatelessWidget {
  // final List<String> imageUrls;
  // final String description;
  final List<Map<String, String>> items;

  ItemDetailsPage({required this.items});

  // ItemDetailsPage({required this.imageUrls, required this.description});

  // double screenHeight = MediaQuery.of(g).size.height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Carousel for item photos
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.5,
              autoPlay: true,
              viewportFraction: 1.0,
              autoPlayInterval: Duration(seconds: 3),
            ),
            items: items.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      // Image section
                      item['image']!.startsWith('http') ||
                              item['image']!.startsWith('https')
                          ? Image.network(
                              item['image']!,
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                            )
                          : Image.asset(
                              item['image']!,
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                            ),
                      SizedBox(
                          height: 10), // Space between image and description
                      // Description section
                      Center(
                        child: Text(
                          item['description']!,
                          style:
                              TextStyle(fontSize: 16, color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
