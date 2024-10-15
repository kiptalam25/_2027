import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/presentation/pages/profile.dart';

import '../../common/helper/navigator/app_navigator.dart';
import '../../common/widgets/button/basic_app_button.dart';
import '../../core/config/themes/app_colors.dart';
import '../../main.dart';
import 'login_page.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(hideBack: true),
        //   title: Text('Registration'),
        // ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 94),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Create Your Account",
                      style: TextStyle(
                        fontSize: 24,
                        // color: Colors.black,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text(
                    'Join our community to start swapping \ntoday',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      // alignment:Alignment.bottomCenter
                      // color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: Text(
                    'Join with email',
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'enter your email',
                          // prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      BasicAppButton(
                        textColor: AppColors.background,
                        backgroundColor: AppColors.primary,
                        title: "Sign Up",
                        radius: 24,
                        onPressed: () {
                          AppNavigator.push(context, ProfilePage());
                        },
                      ),
                      SizedBox(height: 40),

                      Center(
                        child: Text("Or"),
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      SizedBox(
                        width: 374,
                        height: 46, // Set the desired width
                        child: ElevatedButton(
                          onPressed: () {
                            AppNavigator.pushReplacement(context, LoginPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                                0xFFF13C00), // Custom button background color
                            side: BorderSide(
                              color: Color(0xFFF13C00), // Custom border color
                              width: 2, // Border width
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Custom border radius
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center the icon and text
                            children: const [
                              FaIcon(
                                FontAwesomeIcons
                                    .google, // Font Awesome Google icon
                                color: Color(0xFFFFFFFF), // Icon color
                              ),
                              SizedBox(width: 8), // Space between icon and text
                              Text(
                                'Sign up with Google',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF), // Text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      SizedBox(
                        width: 374,
                        height: 46, // Set the desired width
                        child: ElevatedButton(
                          onPressed: () {
                            AppNavigator.pushReplacement(context, LoginPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF3D5A98), // Custom button background color
                            side: const BorderSide(
                              color: Color(0xFF3D5A98), // Custom border color
                              width: 2, // Border width
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Custom border radius
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center the icon and text
                            children: const [
                              FaIcon(
                                FontAwesomeIcons
                                    .facebook, // Font Awesome Google icon
                                color: Color(0xFFFFFFFF), // Icon color
                              ),
                              SizedBox(
                                  width: 10), // Space between icon and text
                              Text(
                                'Sign up with Facebook',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF), // Text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        width: 374,
                        height: 46, // Set the desired width
                        child: ElevatedButton(
                          onPressed: () {
                            AppNavigator.pushReplacement(context, LoginPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                                0xFF000000), // Custom button background color
                            side: BorderSide(
                              color: Color(0xFF000000), // Custom border color
                              width: 2, // Border width
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Custom border radius
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center the icon and text
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset("images/x.png"),
                              ),
                              SizedBox(width: 0), // Space between icon and text
                              Text(
                                'Sign up with X',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF), // Text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // _loginPage(context)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _loginPage(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Do you have an account?",
            style: TextStyle(
              color: Colors.black, // Ensure the text is visible
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: 'Login',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // AppNavigator.pushReplacement(context, LoginPage());
              },
            style: TextStyle(
              color: Colors.blue, // Add a color for the link
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Image at the top
// Padding(
//   padding: const EdgeInsets.only(top: 80.0),
//   child: Image.asset(
//     'images/swapify_login.png', // Ensure the image is in the assets folder
//     height: 200,
//   ),
// ),
