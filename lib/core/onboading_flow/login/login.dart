import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/common/constants/app_constants.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/core/onboading_flow/login/login_bloc.dart';
import 'package:swapifymobile/core/onboading_flow/login/login_event.dart';
import 'package:swapifymobile/core/onboading_flow/login/login_state.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_bloc.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_state.dart';
import 'package:swapifymobile/core/onboading_flow/verification.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';

import '../../../api_client/api_client.dart';
import '../../../auth/services/auth_service.dart';
import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import '../../../common/widgets/button/basic_app_button.dart';
import '../../main/pages/base_page.dart';
import '../../main/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  // final int currentPage;
  // LoginPage({});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//
class _LoginPageState extends State<LoginPage> {
  late SharedPreferences sharedPreferences;
  bool? isAuthenticated;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    checkTokenValidity();
  }

  Future<void> _initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // Save email to SharedPreferences
  Future<void> _saveEmailToPreferences(String email, String password) async {
    await sharedPreferences.setString('email', email);
    await sharedPreferences.setString('password', password);
  }

  checkTokenValidity() async {
    //   isAuthenticated = sharedPreferences?.containsKey("token") ?? false;

    //   BlocProvider.of<LoginBloc>(context).add(
    //     CheckToken(),
    //   );
  }
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting, show a loading indicator
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Handle errors here if needed
            return Center(child: Text('Error loading preferences'));
          }
          return BlocProvider(
            create: (_) => LoginBloc(AuthService(ApiClient()), snapshot.data!),
            child: Scaffold(
              appBar: BasicAppbar(
                // title: PageIndicator(currentPage: widget.currentPage),
                hideBack: true,
                // height: 40,
              ),
              body: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Container(
                          //   child: Center(),
                          // ),
                          Center(child: _buildTitleSection()),
                          // SizedBox(height: 16),
                          Column(
                            children: [
                              _buildInputSection(
                                  "Email", "Enter your email", _emailController,
                                  (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!AppConstants.emailRegex.hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              }, TextInputType.emailAddress),
                              _buildInputPassword("Password",
                                  "Enter your password", _passwordController),
                              SizedBox(height: 27),
                              _blockConsumer(),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                    color:
                                        Colors.blue, // Make it look like a link
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ));
              }),
            ),
          );
        });
  }

//
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          "Login",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Start Swapping.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _blockConsumer() {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          AppNavigator.pushReplacement(context, HomePage());
        } else if (state is LoginFailure) {
          // String jsonString = state.message
          String response = state.message;
          sharedPreferences.clear();
          _saveEmailToPreferences(
              _emailController.text, _passwordController.text);
          // Check if the string contains 'User not verified' Invalid password
          if (response.contains('User not verified')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("User not verified")),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyPage(currentPage: 3),
                ));
          } else if (response.contains('Invalid password')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Invalid username or password")),
            );
          } else if (response.contains('User not found')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("User not found")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response)),
            );
          }
        }
      },
      builder: (context, state) {
        return _buildSignUpButton(context, state);
      },
    );
  }

  Widget _buildInputPassword(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(label),
        SizedBox(height: 20),
        SizedBox(
          // height: 40,
          child: TextFormField(
            obscureText: true,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (!AppConstants.passwordRegex.hasMatch(value)) {
                return 'Password must be at least 8 characters, include\n'
                    'a capital letter, a number, and a special character.';
              }
              return null;
            },
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.lock,
                color: AppColors.textFieldBorder,
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.hintColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 1.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),

              // contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

//
  Widget _buildInputSection(String label, String hintText,
      TextEditingController controller, validator, keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 12),
        SizedBox(
          // height: 40,
          child: TextFormField(
            controller: controller,
            // keyboardType: keyboardType ? keyboardType : ,
            validator: validator,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: AppColors.hintColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: AppColors.textFieldBorder, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.textFieldBorder, width: 1.0),
                ),
                contentPadding: EdgeInsets.all(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context, LoginState state) {
    return BasicAppButton(
      height: 46,
      radius: 24,
      title: "Login",
      onPressed: state is LoginLoading
          ? null
          : () {
              if (_formKey.currentState?.validate() ?? false) {
                BlocProvider.of<LoginBloc>(context).add(
                  LoginSubmitted(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              }
            },
      content: state is LoginLoading
          ?
          // SizedBox(
          // width: 24,
          // height: 24,
          CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
          // )
          : null,
    );
  }
}

//   void _onSubmit(BuildContext context) {
//     AppNavigator.push(
//         context,
//         VerifyPage(
//           currentPage: 2,
//         ));
//     // Collect data from fields
//     // final username = _usernameController.text;
//     // final phone = _phoneController.text;
//     // final email = _emailController.text;
//     // final password = _passwordController.text;
//     // final bio = _bioController.text;
//     //
//     // // Create a JSON object
//     // final Map<String, dynamic> userProfile = {
//     //   'username': username,
//     //   'phone': '$_selectedCountryCode$phone',
//     //   'email': email,
//     //   'password': password,
//     //   'bio': bio,
//     // };
//     //
//     // final jsonString = jsonEncode(userProfile);
//     //
//     // print(jsonString);
//   }
//
//   bool _isValidPhoneNumber(String phoneNumber) {
//     return phoneNumber.length >= 7; // Basic length validation
//   }
//
// // BlocListener<dynamic, dynamic> login() {
// //   return BlocListener<LoginBloc, LoginState>(
// //     listener: (context, state) {
// //       if (state is LoginSuccess) {
// //         Navigator.pushReplacementNamed(context, '/home');
// //       } else if (state is LoginFailure) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(state.error)),
// //         );
// //       }
// //     },
// //     child: BlocBuilder<LoginBloc, LoginState>(
// //       builder: (context, state) {
// //         if (state is LoginLoading) {
// //           return CircularProgressIndicator();
// //         }
// //         // return LoginForm();
// //       },
// //     ),
// //   );
// // }
// // }
// }
