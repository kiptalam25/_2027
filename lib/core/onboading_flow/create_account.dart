import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/auth/login_with_facebook/facebook_login_page.dart';
import 'package:swapifymobile/auth/twitter/login_with_twitter.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/core/main/pages/home_page.dart';
import 'package:swapifymobile/core/onboading_flow/profile_setup.dart';
import 'package:swapifymobile/core/services/auth_service.dart';
import 'package:swapifymobile/core/services/registration_service.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/social_links.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/login_with_google/google_auth_service.dart';
import '../../common/widgets/app_bar.dart';
import '../../common/widgets/basic_app_button.dart';
import '../../common/app_colors.dart';
import '../form_validators.dart';

class Registration extends StatefulWidget {
  final int currentPage;
  Registration({required this.currentPage});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late final RegistrationService registrationService =
      RegistrationService(new ApiClient());
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  String? _errorText;
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();

  String username = '';
  String password = '';

  final GoogleAuthService _googleAuthService = GoogleAuthService();
  bool _isSigningUp = false;

  Future<void> _signUpWithGoogle() async {
    setState(() {
      _isSigningUp = true;
    });

    await _googleAuthService.handleGoogleSignIn(
      isSignIn: false,
      onSuccess: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      onError: (errorMessage) {
        print(errorMessage);
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      },
    );

    setState(() {
      _isSigningUp = false;
    });
  }

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
        body: !_isSigningUp
            ? LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                              height: 16,
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
                              height: 24,
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
                          ],
                        ),
                        Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: SizedBox(
                                // height: 40,
                                child: TextFormField(
                                  controller: _emailController,
                                  onChanged: (value) {
                                    setState(() {
                                      username = value;
                                    });
                                  },
                                  // keyboardType: TextInputType.emailAddress,
                                  validator: FormValidators.validateEmail,
                                  style: TextStyle(),
                                  focusNode: _emailFocusNode,
                                  decoration: InputDecoration(
                                      errorText: _errorText,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide(
                                            color: AppColors.textFieldBorder,
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide(
                                            color: AppColors.textFieldBorder,
                                            width: 1.0),
                                      ),
                                      hintText: 'Enter email',
                                      hintStyle: const TextStyle(
                                          color: AppColors.hintColor),
                                      contentPadding: const EdgeInsets.all(10)),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            BasicAppButton(
                              textColor: AppColors.background,
                              backgroundColor: AppColors.primary,
                              title: "Sign Up",
                              radius: 24,
                              onPressed: isLoading
                                  ? null
                                  : checkAndValidateUsername, // Disable button during loading
                              content: isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : null,

                              // checkAndValidateUsername,
                              // if (_formKey.currentState?.validate() ?? false) {
                              //   if (await emailExists(_emailController.text)) {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => ProfilePage(
                              //             currentPage: 1,
                              //             email: _emailController.text,
                              //           ),
                              //         ));
                              //   }
                              // }
                              // },
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: Text("Or"),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        !_isLoggingIn
                            ? SocialLinks(
                                page: 'signup',
                                onSocialClicked: (social) {
                                  if (social == "google") {
                                    print(social);

                                    signInWithGoogle();
                                  } else if (social == "facebook") {
                                    // signInWithFacebook();
                                    // AppNavigator.pushReplacement(
                                    //     context, FacebookLoginPage());
                                  } else if (social == "x") {
                                    // signInWithFacebook();
                                    // AppNavigator.pushReplacement(
                                    //     context, TwitterLoginPage());
                                  }
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ));
              })
            : CircularProgressIndicator());
  }

  bool _isValidEmail(String email) {
    const emailRegex = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    return RegExp(emailRegex).hasMatch(email);
  }

  bool _isLoggingIn = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: ApiConstants.googleServerClientId,
    scopes: ['email'],
  );

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      // Initialize Google Sign-In
      final GoogleSignInAccount? googleUser =
          await await _googleSignIn.signIn();
      if (googleUser == null) {
        print('User canceled the sign-in process.');
        return;
      }
      // '114477559991-6m6biub2pm915e6j6fjjo5fev2jdsql8.apps.googleusercontent.com ',
      print('Signed in as ${googleUser.displayName}');
      // Authenticate and get tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final idToken = googleAuth.idToken;
      if (idToken == null) {
        setState(() {
          _isLoggingIn = false;
        });
        return;
      }

      // Send ID Token to backend using Dio
      AuthService authService = AuthService(ApiClient());

      print("Token.................." + idToken);
      final response = await authService.loginWithGoogle(idToken);

      // Dio().post(
      //   ApiConstants.loginGoogle, // Replace with your backend endpoint
      //   data: jsonEncode({'idToken': idToken}),
      //   options: Options(
      //     headers: {'Content-Type': 'application/json'},
      //   ),
      // );

      // Handle response
      if (response.success) {
        AppNavigator.pushAndRemove(context, HomePage());
        // final response =
        //     await Dio().get(ApiConstants.loginGoogle, data: {
        //   'idToken': googleAuth.accessToken,
        // });
        // You can now save the token or navigate to the next screen
      } else {
        print('Failed to authenticate with backend: ${response.message}');
      }
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.data}');
      } else if (e is PlatformException) {
        print("PlatformException Code: ${e.code}");
        print("PlatformException Message: ${e.message}");
        // You can also add custom handling based on error codes, if necessary
      } else {
        print('Error during Google Sign-In: $e');
      }
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  Future<void> checkAndValidateUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    final username = _emailController.text.trim();

    if (username.isEmpty) {
      setState(() {
        _errorText = 'Username is required';
      });
      _emailFocusNode.requestFocus();
      return;
    }

    final isEmail = _isValidEmail(username);
    if (!isEmail) {
      setState(() {
        _errorText = 'Enter a valid email (min 3 characters)';
      });
      _emailFocusNode.requestFocus();
      return;
    }

    setState(() {
      isLoading = true; // Show loading spinner
      _errorText = null; // Clear previous error
    });

    try {
      final result = await registrationService.checkEmail(username);

      if (result.success && !result.available) {
        setState(() {
          _errorText = result.message; // e.g., "Username is taken"
        });
        _emailFocusNode.requestFocus();
      } else if (result.available) {
        setState(() {
          // isLoading = true;
          _errorText = null; // Clear the error if the username is valid
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                currentPage: 1,
                email: _emailController.text,
              ),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      print("Error .............................+" + e.toString());
      setState(() {
        _errorText =
            'Connection: Failed to validate username.\n Please try again.';
      });
      _emailFocusNode.requestFocus();
    } finally {
      setState(() {
        isLoading = false; // Hide loading spinner
      });
    }
  }
}
