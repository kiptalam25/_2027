import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/services/profile_service.dart';

import '../../api_client/api_client.dart';
import '../services/auth_service.dart';
import '../../common/widgets/basic_app_button.dart';
import '../usecases/location.dart';
import '../usecases/profile_response.dart';
import '../usecases/profile_update_request.dart';
import '../widgets/custom_dropdown.dart';

class EditProfilePage extends StatefulWidget {
  // ProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  ProfileService profileService = ProfileService(new ApiClient());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  UserProfileResponse? profile;
  @override
  void initState() {
    _fetchProfile();
    _selectedCountry = countries.first['id'];
    _selectedCity = cities.first['id'];
    super.initState();
  }

  Future<void> _fetchProfile() async {
    try {
      // Fetch the profile
      var profile1 = await profileService.fetchProfile();

      // Handle the fetched profile outside setState
      String fullName = profile1?.profile.fullName ?? '';
      String bio = profile1?.profile.bio ?? '';
      String profilePicUrl = profile1?.profile.profilePicUrl ?? '';

      String? countryName = profile1?.profile.location?.country;
      _selectedCountry = countries.firstWhere(
        (item) => item['id'] == countryName,
        orElse: () => countries.first, // Fallback to the first city
      )['id'];

      String? cityName = profile1?.profile.location?.city;
      _selectedCity = cities.firstWhere(
        (item) => item['id'] == cityName,
        orElse: () => cities.first, // Fallback to the first city
      )['id'];

      // Update state variables
      setState(() {
        profile = profile1;
        _fullNameController.text = fullName;
        _bioController.text = bio;
        uploadedUrl = profilePicUrl;
        // _selectedCity = city;
      });

      print("Profile fetched successfully.");
    } catch (e) {
      // Handle errors gracefully
      print("Error fetching profile: $e");
    }
  }

  File? _image;
  bool isUploadingImage = false;

  // Function to pick an image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image
      });
      _uploadImage();
    }
  }

  late String uploadedUrl;

  Future<bool> _uploadImage() async {
    setState(() {
      isUploadingImage = true;
    });
    const cloudName = "dqjv3o9zi";
    // const apiKey = "672828653332493";
    // const apiSecret = "lTbaGnstK6FWbVl92Q_ckPXPYKI";
    const uploadPreset = "l9sim6rm";

    final dio = Dio();
    List<String> uploadedUrls = [];

    try {
      // for (var image in _imageFiles!) {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(_image!.path),
        "upload_preset": uploadPreset,
      });

      final response = await dio.post(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
        data: formData,
      );

      if (response.statusCode == 200) {
        setState(() {
          isUploadingImage = false;
        });
        // Extract URL from the response
        String imageUrl = response.data['secure_url'];
        uploadedUrl = imageUrl;
        setState(() {
          uploadedUrl = imageUrl;
        });
        return true;
      }
      return false;
      print("Uploaded URLs: $uploadedUrl");
    } catch (e) {
      print("Error uploading profile picture: $e");
      return false;
    }
  }

  String getImageUrlAsJson() {
    final Map<String, dynamic> jsonMap = {
      "profilePicUrl": uploadedUrl,
    };
    return jsonEncode(jsonMap);
  }

  _updateProfile() async {
    try {
      final profileUpdateData = ProfileUpdateRequest(
          fullName: _fullNameController.text,
          profilePicUrl: uploadedUrl != null ? uploadedUrl : "",
          bio: _bioController.text,
          location: Location(country: _selectedCountry!, city: _selectedCity!));

      // Convert to JSON for API request
      final requestData = profileUpdateData.toJson();

      final response = await profileService.updateProfile(requestData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
      _fetchProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  // final sharedPreferences = await SharedPreferences.getInstance();

  List<Map<String, String>> countries = [
    {'id': 'estonia', 'name': 'Estonia'},
    {'id': 'finland', 'name': 'Finland'},
  ];
  List<Map<String, String>> cities = [
    {'id': 'city1', 'name': 'City1'},
    {'id': 'city2', 'name': 'City2'},
  ];

  String? _selectedCountry;
  String? _selectedCity;
  final AuthService _authService = AuthService(ApiClient());

  var textLength = 0;
  // Default country code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: BasicAppbar(
        //   // title: PageIndicator(currentPage: widget.currentPage),
        //   hideBack: true,
        //   // height: 40,
        // ),
        body: profile != null
            ? LayoutBuilder(builder: (context, constraints) {
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
                          SizedBox(
                            height: 16,
                          ),
                          _buildInputSection("FullName", "Enter your full name",
                              _fullNameController, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          }, null),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Country"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 40,
                            child: CustomDropdown(
                              value: _selectedCountry,
                              items: countries,
                              // hintText: 'Country*',
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCountry = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("City"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 40,
                            child: CustomDropdown(
                              value: _selectedCity,
                              items: cities,
                              // hintText: 'City*',
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCity = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Bio"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            // height: 40,
                            child: TextFormField(
                              controller: _bioController,
                              maxLength: 200,
                              maxLines: 5, // Maximum lines before scroll
                              minLines: 5,
                              decoration: InputDecoration(
                                hintText: "Tell us something fun about you",
                                hintStyle: TextStyle(color: Colors.grey),
                                isDense:
                                    true, // Reduces vertical padding for compactness
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.textFieldBorder,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.textFieldBorder,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                counterText: '', // Hides character counter
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Minimum 25 characters required';
                                }
                                if (value.length < 25) {
                                  return 'Minimum 25 characters required';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  textLength = _bioController.text.length;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, right: 5),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${textLength}/200',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),

                          // _textareaBio("Bio", "Tell us something fun about you",
                          //     _bioController),
                          SizedBox(height: 27),
                          _buildSignUpButton(context),

                          SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ));
              })
            : Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ));
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          "Update Your Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        // Text(
        //   'Tell us about yourself.',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(fontSize: 12),
        // ),
      ],
    );
  }

  void saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    print("Credentials Saved................................................");
    print(email);
    print(password);
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
                            image: NetworkImage(
                                profile!.profile.profilePicUrl.toString()),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                if (uploadedUrl == "") ...[
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Icon(
                        Icons.person_outline,
                        size: 32,
                        color: AppColors.primary,
                      )),
                ],
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
            children: [
              Text(profile!.profile.fullName.toString(),
                  style: TextStyle(fontSize: 20)),
              Text("SwapLord", style: TextStyle(fontSize: 16)),
              Text("Rating 0", style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  bool _isObscured = true;

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
            obscureText: _isObscured,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              final passwordRegEx =
                  r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

              if (!RegExp(passwordRegEx).hasMatch(value)) {
                return 'Password must be at least 8 characters long,\n '
                    'include an uppercase letter, lowercase letter, \n'
                    'a number, and a special character.';
              }
              return null;
            },
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured; // Toggle password visibility
                  });
                },
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
          // height: 40,
          child: TextFormField(
            enabled: true,
            controller: controller,
            // maxLength: maxCharacters > 0 ? maxCharacters : null,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              isDense: true, // Reduces vertical padding for compactness
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.textFieldBorder, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              counterText: '', // Hides character counter
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              // if (value.length < minCharacters!) {
              //   return 'Minimum $minCharacters characters required';
              // }
              return null;
            },
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
            controller: _bioController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              isDense: true,
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

  Widget _buildSignUpButton(BuildContext context) {
    return BasicAppButton(
      height: 46,
      radius: 24,
      title: "Update",
      onPressed: () => {
        if (_formKey.currentState?.validate() ?? false) {_updateProfile()}
      },
      content: isUploadingImage
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

  Future<void> saveUserData(RegisterUser registerUser) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData =
        jsonEncode(registerUser.toJson()); // Convert to JSON string
    await prefs.setString('registerUser', userData); // Save JSON string
  }
}
