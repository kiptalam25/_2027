import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/presentation/pages/forgot_password.dart';

import '../../common/helper/navigator/app_navigator.dart';

class EnterPasswordPage extends StatelessWidget {
  const EnterPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'images/img.png', // Ensure the image is in the assets folder
                  height: 200,
                ),
              ),
              _signinText(context),
              const SizedBox(
                height: 10,
              ),
              _emailField(context),
              const SizedBox(height: 10),
              _continueButton(context),
              const SizedBox(
                height: 10,
              ),
              _forgoPassword(context)
            ],
          ),
        ));
  }

  Widget _signinText(BuildContext context) {
    return Text(
      "Password",
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  _forgoPassword(BuildContext context) {
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
                AppNavigator.push(context, const ForgotPasswordPage());
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
        // Add your login logic here
      },
      style: ElevatedButton.styleFrom(
        // padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Color(0xFF50644C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Continue',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Enter Password",
        labelText: 'Password',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
