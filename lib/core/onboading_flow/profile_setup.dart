import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/common/constants/app_constants.dart';
import 'package:swapifymobile/core/config/themes/app_colors.dart';
import 'package:swapifymobile/core/onboading_flow/categories_page.dart';
import 'package:swapifymobile/core/onboading_flow/choose.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_bloc.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_state.dart';
import 'package:swapifymobile/core/onboading_flow/verification.dart';
import 'package:swapifymobile/core/onboading_flow/widgets/page_indicator.dart';

import '../../api_client/api_client.dart';
import '../../auth/models/user_model.dart';
import '../../auth/services/auth_service.dart';
import '../../common/helper/navigator/app_navigator.dart';
import '../../common/widgets/appbar/app_bar.dart';
import '../../common/widgets/button/basic_app_button.dart';
import 'login/login_bloc.dart';
import 'login/login_event.dart';
import 'login/login_state.dart';

class ProfilePage extends StatefulWidget {
  // ProfilePage({Key? key}) : super(key: key);

  final int currentPage;
  final String email;
  ProfilePage({required this.currentPage, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    _updateText();
    super.initState();
  }

  void _updateText() {
    setState(() {
      _emailController.text = widget.email;
    });
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  // final sharedPreferences = await SharedPreferences.getInstance();

  String? _selectedCountryCode;
  final AuthService _authService = AuthService(ApiClient());

  // Future<void> _register() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     try {
  //       UserModel user = await _authService.register(
  //         _emailController.text,
  //         _passwordController.text,
  //         _usernameController.text,
  //         _phoneController.text,
  //         _bioController.text,
  //       );
  //       // Handle success, e.g., navigate to the home page
  //       print('User registered: ${response.message}');
  //       const snackBar = SnackBar(
  //         content: Text('User registered:'),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     } catch (e) {
  //       // Handle error, e.g., show error message
  //       print('Registration error: $e');
  //     }
  //   }
  // }

  // Default country code
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegistrationBloc(AuthService(ApiClient())),
      child: Scaffold(
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
                    SizedBox(height: 16),
                    _buildProfileImageSection(),
                    _buildInputSection(
                        "FullName", "Enter your full name", _fullNameController,
                        (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    }, null),
                    SizedBox(
                      height: 16,
                    ),
                    _buildInputSection(
                        "Username", "Enter your username", _usernameController,
                        (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    }, null),
                    _buildPhoneInputSection(),
                    SizedBox(
                      height: 16,
                    ),

                    _buildInputSection(
                        "Email", "Enter your email", _emailController, (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!AppConstants.emailRegex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    }, TextInputType.emailAddress),
                    _buildInputPassword(
                        "Password", "Enter your password", _passwordController),
                    _textareaBio("Bio", "Tell us something fun about you",
                        _bioController),
                    SizedBox(height: 27),
                    BlocConsumer<RegistrationBloc, RegistrationState>(
                      listener: (context, state) {
                        if (state is RegistrationSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registration successful')),
                          );

                          BlocProvider.of<RegistrationBloc>(context)
                              .add(ResendVerificationEmail(
                            _emailController.text,
                          ));
                          final _fullPhoneNumber =
                              '$_selectedCountryCode${_phoneController.text}';
                          saveUserData(
                            RegisterUser(
                              fullName: _fullNameController.text,
                              email: _emailController.text,
                              password: "",
                              name: _usernameController.text,
                              phoneNumber: _fullPhoneNumber,
                              bio: _bioController.text,
                            ),
                          );

                          saveCredentials(
                              _emailController.text, _passwordController.text);

                          AppNavigator.push(
                              context,
                              VerifyPage(
                                currentPage: 3,
                              ));
                        } else if (state is RegistrationError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return _buildSignUpButton(context, state);
                      },
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
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          "Set Up Your Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Tell us about yourself.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  File? _image;

  // Function to pick an image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image
      });
    }
  }

  void saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Widget _buildProfileImageSection() {
    return Row(
      children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage('images/default_user.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      // Show a dialog to choose between camera and gallery
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Choose a source'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera); // Open camera
                              },
                              child: Text('Camera'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery); // Open gallery
                              },
                              child: Text('Gallery'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 24, // Adjust size as needed
                      color: AppColors.primary, // Optional: change color
                    ),
                  ),
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
        SizedBox(height: 20),
        SizedBox(
          height: 40,
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

  Widget _buildInputSection(String label, String hintText,
      TextEditingController controller, validator, keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 12),
        SizedBox(
          height: 40,
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
          child: TextFormField(
            controller:
                _bioController, // You can assign a TextEditingController here
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
                  // errorMaxLines: 2,
                  // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
                  setState(() {
                    _selectedCountryCode = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a country code' : null,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!_isValidPhoneNumber(value)) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: AppColors.textFieldBorder, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
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

  Widget _buildSignUpButton(BuildContext context, RegistrationState state) {
    return BasicAppButton(
      height: 46,
      radius: 24,
      title: "Sign Up",
      onPressed: state is RegistrationLoading
          ? null
          : () {
              // AppNavigator.push(
              //     context,
              //     VerifyPage(
              //       currentPage: 2,
              //     ));
              if (_formKey.currentState?.validate() ?? false) {
                final _fullPhoneNumber =
                    '$_selectedCountryCode${_phoneController.text}';
                BlocProvider.of<RegistrationBloc>(context).add(
                  RegisterUser(
                    fullName: _fullNameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    name: _usernameController.text,
                    phoneNumber: _fullPhoneNumber,
                    bio: _bioController.text,
                  ),
                );
              }
            },
      content: state is RegistrationLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : null,
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

  bool _isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.length >= 7; // Basic length validation
  }

  Future<void> saveUserData(RegisterUser registerUser) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData =
        jsonEncode(registerUser.toJson()); // Convert to JSON string
    await prefs.setString('registerUser', userData); // Save JSON string
  }

  // BlocListener<dynamic, dynamic> login() {
  //   return BlocListener<LoginBloc, LoginState>(
  //     listener: (context, state) {
  //       if (state is LoginSuccess) {
  //         Navigator.pushReplacementNamed(context, '/home');
  //       } else if (state is LoginFailure) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(state.error)),
  //         );
  //       }
  //     },
  //     child: BlocBuilder<LoginBloc, LoginState>(
  //       builder: (context, state) {
  //         if (state is LoginLoading) {
  //           return CircularProgressIndicator();
  //         }
  //         // return LoginForm();
  //       },
  //     ),
  //   );
  // }
  // }
}
