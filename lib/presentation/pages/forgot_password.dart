import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';

import 'login_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _signinText(context),
              const SizedBox(
                height: 20,
              ),
              _emailField(context),
              const SizedBox(height: 20),
              _continueButton(context),
              const SizedBox(
                height: 20,
              ),
              // _createAccount(context)
            ],
          ),
        ));
  }

  Widget _signinText(BuildContext context) {
    return Text(
      "Email",
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  _createAccount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Forgot Password?",
            style: TextStyle(
              color: Colors.black, // Ensure the text is visible
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: ' Reset',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Your action here
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

  Widget _continueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AppNavigator.pushReplacement(context, LoginPage());
      },
      style: ElevatedButton.styleFrom(
        // padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Color(0xFF50644C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Reset Password',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Enter Email",
        labelText: 'Email',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
