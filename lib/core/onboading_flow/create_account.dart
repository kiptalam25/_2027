import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swapifymobile/core/onboading_flow/profile_setup.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';

import '../../common/helper/navigator/app_navigator.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../../common/widgets/button/basic_app_button.dart';
import '../config/themes/app_colors.dart';

class Registration extends StatefulWidget {
  final int currentPage;
  Registration({required this.currentPage});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
          hideBack: true,
          title: PageIndicator(
            currentPage: widget.currentPage,
          ),
        ),
        //   title: Text('Registration'),
        // ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: const BoxDecoration(
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
                      SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                          style: TextStyle(),
                          decoration: InputDecoration(
                            labelText: 'enter your email',
                            // contentPadding: EdgeInsets.symmetric(vertical: 12),
                            // prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  style: BorderStyle.solid, width: 1),
                              borderRadius: BorderRadius.circular(24),
                            ),
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
                          AppNavigator.push(
                              context,
                              ProfilePage(
                                currentPage: 1,
                              ));
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
                            // AppNavigator.pushReplacement(context, LoginPage());
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
                            // AppNavigator.pushReplacement(context, LoginPage());
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
                            // AppNavigator.pushReplacement(context, LoginPage());
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
}
