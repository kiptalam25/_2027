import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapifymobile/common/widgets/appbar/app_bar.dart';
import 'package:swapifymobile/presentation/pages/popup.dart';
import 'package:swapifymobile/presentation/pages/verify.dart';
import '../../common/helper/navigator/app_navigator.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String _selectedCountryCode = '+1'; // Default country code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        height: 40,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              Container(
                child: Center(),
              ),
              _buildTitleSection(),
              SizedBox(height: 10),
              _buildProfileImageSection(),
              _buildInputSection(
                  "Username", "Enter your username", _usernameController),
              _buildPhoneInputSection(),
              _buildInputSection("Email", "Enter your email", _emailController),
              _buildInputPassword(
                  "Password", "Enter your password", _passwordController),
              _textareaBio(
                  "Bio", "Tell us something fun about you", _bioController),
              SizedBox(height: 20),
              _buildSignUpButton(context),
              _showPopup(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          "Set up your profile",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Tell us about yourself.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Row(
      children: [
        Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'images/default_user.png', // Ensure the image is in the assets folder
                  height: 100,
                  width: 100,
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("New User", style: TextStyle(fontSize: 24)),
              Text("SwapLord", style: TextStyle(fontSize: 16)),
              Text("Rating 0", style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputPassword(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(label),
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(label),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ],
    );
  }

  Widget _textareaBio(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(label),
        TextField(
          controller:
              _bioController, // You can assign a TextEditingController here
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLines: null, // Allows unlimited lines
          keyboardType: TextInputType.multiline, // Allows multi-line input
        ),
      ],
    );
  }

  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text("Phone Number"),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                // padding: EdgeInsets.symmetric(
                //     horizontal:
                //         8), // Padding around the DropdownButtonFormField
                child: SizedBox(
                  height: 50,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    value: _selectedCountryCode,
                    items: [
                      DropdownMenuItem(
                          value: '+254', child: Text('+254 (Kenya)')),
                      DropdownMenuItem(value: '+1', child: Text('+1 (USA)')),
                      DropdownMenuItem(value: '+44', child: Text('+44 (UK)')),
                      DropdownMenuItem(
                          value: '+91', child: Text('+91 (India)')),
                    ],
                    onChanged: (value) {
                      // setState(() {
                      _selectedCountryCode = value!;
                      // });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 6,
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(left: 10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: 374,
      height: 46, // Set the desired width
      child: ElevatedButton(
        onPressed: () {
          AppNavigator.push(context, VerifyPage());
          // _onSubmit(context);
        }, // When button is pressed
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF50644C),
          side: BorderSide(
            color: Color(0xFF50644C), // Custom border color
            // width: 2, // Border width
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Custom border radius
          ),
        ),
        child: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    AppNavigator.push(context, const VerifyPage());
    // Collect data from fields
    // final username = _usernameController.text;
    // final phone = _phoneController.text;
    // final email = _emailController.text;
    // final password = _passwordController.text;
    // final bio = _bioController.text;
    //
    // // Create a JSON object
    // final Map<String, dynamic> userProfile = {
    //   'username': username,
    //   'phone': '$_selectedCountryCode$phone',
    //   'email': email,
    //   'password': password,
    //   'bio': bio,
    // };
    //
    // final jsonString = jsonEncode(userProfile);
    //
    // print(jsonString);
  }

  Widget _showPopup(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showCustomPopup(context); // Show the pop-up
      },
      child: Text('Show Pop-up'),
    );
  }
}
