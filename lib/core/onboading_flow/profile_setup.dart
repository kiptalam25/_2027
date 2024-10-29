import 'package:flutter/material.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/core/onboading_flow/verification.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';

import '../../common/helper/navigator/app_navigator.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../../common/widgets/button/basic_app_button.dart';

class ProfilePage extends StatefulWidget {
  // ProfilePage({Key? key}) : super(key: key);
  final int currentPage;
  ProfilePage({required this.currentPage});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  String _selectedCountryCode = '+1';
  // Default country code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: PageIndicator(currentPage: widget.currentPage),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   child: Center(),
                // ),
                Center(child: _buildTitleSection()),
                SizedBox(height: 16),
                _buildProfileImageSection(),
                _buildInputSection(
                    "Username", "Enter your username", _usernameController),
                _buildPhoneInputSection(),
                SizedBox(
                  height: 16,
                ),
                _buildInputSection(
                    "Email", "Enter your email", _emailController),
                _buildInputPassword(
                    "Password", "Enter your password", _passwordController),
                _textareaBio(
                    "Bio", "Tell us something fun about you", _bioController),
                SizedBox(height: 27),
                _buildSignUpButton(context),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ));
      }),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          "Set Up Your Profile",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 16,
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
            children: const [
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
        SizedBox(height: 16),
        Text(label),
        SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: TextField(
            obscureText: true,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.lock,
                color: AppColors.textFieldBorder,
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.hintColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 1.0),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
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
        Text(label),
        SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.hintColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 1.0),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
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
        SizedBox(height: 16),
        Text(label),
        SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 83,
          child: TextField(
            controller:
                _bioController, // You can assign a TextEditingController here
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.hintColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 1.0),
              ),
            ),
            maxLines: null, // Allows unlimited lines
            keyboardType: TextInputType.multiline, // Allows multi-line input
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Phone Number"),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 40,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.textFieldBorder, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.textFieldBorder, width: 1.0),
                  ),
                ),
                style: TextStyle(fontSize: 16, color: Colors.black),
                value: _selectedCountryCode,
                items: [
                  DropdownMenuItem(value: '+254', child: Text('+254')),
                  DropdownMenuItem(value: '+1', child: Text('+1')),
                  DropdownMenuItem(value: '+44', child: Text('+44')),
                  DropdownMenuItem(value: '+91', child: Text('+91')),
                ],
                onChanged: (value) {
                  // setState(() {
                  _selectedCountryCode = value!;
                  // });
                },
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.textFieldBorder, width: 2.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.textFieldBorder, width: 1.0),
                    ),
                    hintText: 'Enter phone number',
                    hintStyle: const TextStyle(color: AppColors.hintColor),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // Widget _buildPhoneInputSection() {
  //   return Column(
  //     children: [
  //       Text("Phone Number"),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [Text("data"), Text("Data2")],
  //       )
  //     ],
  //   );
  // crossAxisAlignment: CrossAxisAlignment.start,
  // children: [
  //   SizedBox(height: 20),
  //   Text("Phone Number"),
  //   SizedBox(height: 10),
  //   Row(
  //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       TextField(
  //         style: ,
  //       )
  // SizedBox(
  //   height: 40,
  //   child: DropdownButtonFormField<String>(
  //     decoration: InputDecoration(
  //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //     style: TextStyle(fontSize: 16, color: Colors.black),
  //     value: _selectedCountryCode,
  //     items: [
  //       DropdownMenuItem(value: '+254', child: Text('+254 (Kenya)')),
  //       DropdownMenuItem(value: '+1', child: Text('+1 (USA)')),
  //       DropdownMenuItem(value: '+44', child: Text('+44 (UK)')),
  //       DropdownMenuItem(value: '+91', child: Text('+91 (India)')),
  //     ],
  //     onChanged: (value) {
  //       // setState(() {
  //       _selectedCountryCode = value!;
  //       // });
  //     },
  //   ),
  // ),
  // SizedBox(width: 10),
  // SizedBox(
  //   height: 40,
  //   child: TextFormField(
  //     controller: _phoneController,
  //     keyboardType: TextInputType.phone,
  //     decoration: InputDecoration(
  //         labelText: 'Phone Number',
  //         border: OutlineInputBorder(),
  //         contentPadding: EdgeInsets.only(left: 10)),
  //   ),
  // ),
  //       ],
  //     ),
  //   ],
  // );
  // }

  Widget _buildSignUpButton(BuildContext context) {
    return BasicAppButton(
      height: 46,
      radius: 24,
      title: "Sign Up",
      onPressed: () {
        AppNavigator.push(
            context,
            VerifyPage(
              currentPage: 2,
            ));
      },
    );
  }

  void _onSubmit(BuildContext context) {
    AppNavigator.push(
        context,
        VerifyPage(
          currentPage: 2,
        ));
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
}
