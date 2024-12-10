import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/auth/login/login.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';

import '../../common/app_colors.dart';
import '../../common/constants/app_constants.dart';
import '../../common/widgets/app_bar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isOTPSent = false;
  bool isOTPVerified = false;
  bool isPasswordUpdated = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  _sendOTP() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        // title: PageIndicator(currentPage: widget.currentPage),
        hideBack: false,
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
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container(
                  //   child: Center(),
                  // ),
                  Center(child: _buildTitleSection()),
                  // SizedBox(height: 16),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isOTPSent)
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
                      if (isOTPSent && !isOTPVerified) ...[
                        SizedBox(
                          height: 16,
                        ),
                        Text("One Time Password is sent to your email"),
                        _buildInputSection(
                            "Email", "Enter OTP", _emailController, (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter OTP';
                          }
                          if (!AppConstants.emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        }, TextInputType.emailAddress),
                      ],
                      SizedBox(height: 16),
                      if (isOTPVerified) ...[
                        Column(
                          children: [
                            _buildInputPassword("Password",
                                "Enter new password", _passwordController),
                            SizedBox(
                              height: 16,
                            ),
                            _buildInputPassword(
                                "Password", "Re-Enter new password", null),
                            SizedBox(
                              height: 16,
                            )
                          ],
                        ),
                      ],
                      if (!isOTPSent)
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isOTPSent = true;
                              });
                            },
                            child: Text("Send OTP")),
                      if (isOTPSent && !isOTPVerified)
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isOTPVerified = true;
                              });
                            },
                            child: Text("verify OTP")),
                      if (isOTPVerified)
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isPasswordUpdated = true;
                              });
                              AppNavigator.pushAndRemove(context, LoginPage());
                            },
                            child: Text("Submit Password"))
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
    );
  }

  Widget _buildInputSection(String label, String hintText,
      TextEditingController controller, validator, keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        SizedBox(
          // height: 40,
          child: TextFormField(
            controller: controller,
            // keyboardType: keyboardType ? keyboardType : ,
            validator: validator,
            decoration: _decoration(hintText),
          ),
        ),
      ],
    );
  }

  Widget _buildInputPassword(
      String label, String hintText, dynamic controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 16),
        // SizedBox(height: 20),
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
              decoration: _decoration(hintText)),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Reset Your Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          !isOTPSent ? 'Send OTP to reset.' : 'Use OTP to reset',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
        border: UnderlineInputBorder(),
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColors.primary, width: 1.0),
        ),
        // hintText: 'Enter password',
        hintStyle: const TextStyle(color: AppColors.hintColor),
        contentPadding: const EdgeInsets.all(10));
  }
}
