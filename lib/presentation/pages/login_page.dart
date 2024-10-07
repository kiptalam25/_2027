import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/presentation/pages/enter_password.dart';
import 'package:swapifymobile/common/helper/navigator/app_navigator.dart';
import 'package:swapifymobile/presentation/pages/registration.dart';

import '../../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

Widget _signinText(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    // crossAxisAlignment: CrossAxisAlignment.center/
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Image.asset(
          'images/swapify_login.png', // Ensure the image is in the assets folder
          height: 200,
        ),
      ),
    ],
  );
}

Widget _createAccount(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "Dont you have an account?",
          style: TextStyle(
            color: Colors.black, // Ensure the text is visible
            fontSize: 16,
          ),
        ),
        TextSpan(
          text: 'Create One',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              AppNavigator.pushReplacement(context, Registration());
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
      AppNavigator.push(context, const EnterPasswordPage());
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
      hintText: "Enter Email",
      labelText: 'Email',
      prefixIcon: Icon(Icons.person),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Login'),
        // ),
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _signinText(context)),
          const SizedBox(
            height: 20,
          ),
          _emailField(context),
          const SizedBox(height: 20),
          _continueButton(context),
          const SizedBox(
            height: 20,
          ),
          _createAccount(context)
        ],
        // child : Container(
        //
        //   padding: EdgeInsets.symmetric(horizontal: 20),
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         AppColors.customSwatch.shade50,
        //         Colors.white,//lightGreenAccent, // You can mix with predefined colors or other custom colors
        //       ],
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //     ),
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //
        //       Padding(
        //         padding: const EdgeInsets.only(top: 80.0),
        //         child: Image.asset(
        //           'images/swapify_login.png', // Ensure the image is in the assets folder
        //           height: 200,
        //         ),
        //       ),
        //       // Username and Password Fields
        //       Padding(
        //         padding: const EdgeInsets.only(bottom: 180.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             TextField(
        //               onChanged: (value) {
        //                 setState(() {
        //                   username = value;
        //                 });
        //               },
        //               decoration: InputDecoration(
        //                 labelText: 'Username',
        //                 prefixIcon: Icon(Icons.person),
        //                 border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(10),
        //                 ),
        //               ),
        //             ),
        //             SizedBox(height: 20),
        //             TextField(
        //               onChanged: (value) {
        //                 setState(() {
        //                   password = value;
        //                 });
        //               },
        //               obscureText: true,
        //               decoration: InputDecoration(
        //                 labelText: 'Password',
        //                 prefixIcon: Icon(Icons.lock),
        //                 border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(10),
        //                 ),
        //               ),
        //             ),
        //             SizedBox(height: 20),
        //             ElevatedButton(
        //               onPressed: () {
        //                 // Add your login logic here
        //               },
        //
        //               style: ElevatedButton.styleFrom(
        //                 padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Color(0xFF50644C),
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(10),
        //                 ),
        //               ),
        //               child: Text(
        //                 'Continue',
        //                 style: TextStyle(fontSize: 18),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    ));
  }
}
