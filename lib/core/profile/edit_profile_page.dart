import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/api_constants/api_constants.dart';
import 'package:swapifymobile/common/app_colors.dart';
import 'package:swapifymobile/core/main/widgets/loading.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/services/location_service.dart';
import 'package:swapifymobile/core/services/profile_service.dart';
import 'package:swapifymobile/extensions/string_casing_extension.dart';

import '../../api_client/api_client.dart';
import '../../common/widgets/basic_app_button.dart';
import '../services/sharedpreference_service.dart';
import '../usecases/location.dart';
import '../usecases/profile_data.dart';
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
  LocationService locationService = LocationService(new ApiClient());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  UserProfileResponse? profile;

  bool isUpdating=false;





  @override
  void initState() {
    getProfileData();
    fetchCities();
    // _fetchProfile();

    _selectedCountry = "EE";
    // _selectedCity = cities.first['name'];
    super.initState();
  }


  Location? location=null;

  /**
   * Take User profile data from Local storage
   *
   *
   * **/
  Future<void> getProfileData() async {

    ProfileData? profileData1=await SharedPreferencesService.getProfileData();
    print(profileData1?.fullName);

    final location1 = profileData1?.location;
    if(location1!=null){
      setState(() {
        location=location1;
      });
    }else{
      print("............................No Location..................................");
    }
    if (profileData1 != null) {
      // Decode the JSON string back into a Map


      setState(() {
        profile=UserProfileResponse(success: true, message: 'auto', profile: profileData1);
        // profile?.profile = profileData1;
      });

      String fullName = profileData1.fullName ?? '';
      String bio = profileData1.bio ?? '';
      String profilePicUrl = profileData1.profilePicUrl ?? '';


      // Update state variables
      setState(() { 
        // profile = profile1;
        _fullNameController.text = fullName.toTitleCase;
        _bioController.text = bio.toCapitalized;
        uploadedUrl = profilePicUrl;
        if (location!=null) {
          print("...................................Not null.........................");
            String? cityName = profileData1.location?.city;

          _selectedCity=cityName;
        }

      });
      // return jsonDecode(profileJson);
    }else{
      print("............................Profile data is null..................................");

    }
    // return null;
  }

  Future<void> _fetchProfile() async {
    try {
      // Fetch the profile
      var profile1 = await profileService.fetchProfile();

      if(profile1!=null){
        SharedPreferencesService.setProfileData(profile1.profile);
      }

      // Handle the fetched profile outside setState
      String fullName = profile1?.profile.fullName ?? '';
      String bio = profile1?.profile.bio ?? '';
      String profilePicUrl = profile1?.profile.profilePicUrl ?? '';


      // Update state variables
      setState(() {
        profile = profile1;
        _fullNameController.text = fullName.toTitleCase;
        _bioController.text = bio.toCapitalized;
        uploadedUrl = profilePicUrl;
        if (cities.isNotEmpty) {
          String? cityName = profile1?.profile.location?.city;
          _selectedCity = cities.firstWhere(
                (city) => city['name']?.toLowerCase() == cityName?.toLowerCase(),
            orElse: () => cities.first, // Fallback to the first city if no match
          )['name']?.toTitleCase;
        } else {
          _selectedCity = null; // Handle empty list case
        }

      });

      print("Profile fetched successfully.");
    } catch (e) {
      // Handle errors gracefully
      print("Error fetching profile: $e");
    }
  }

  File? _image=null;
  bool isUploadingImage = false;

  // Function to pick an image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
print("..........................................Picking Image..........................................");
    final pickedFile = await picker.pickImage(source: source);
    print(pickedFile?.name);

    if (pickedFile != null) {
      print("..........................................Picked Picture..........................................");
      setState(() {
        _image = File(pickedFile.path); // Update the image
      });
      if(await _uploadImage()){
        print("...................................Picture.......Uploaded..........................................");
      }
    }
  }

  late String uploadedUrl;

  Future<bool> _uploadImage() async {
    print("..........................................Uploading Image..........................................");

    setState(() {
      isUploadingImage = true;
    });

    final dio = Dio();

    try {
      // for (var image in _imageFiles!) {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(_image!.path),
        "upload_preset": ApiConstants.profileUploadPreset,
      });

      final response = await dio.post(ApiConstants.imageUploadUrl,
        data: formData,
      );

      if (response.statusCode == 200) {
        setState(() {
          isUploadingImage = false;
        });
        // Extract URL from the response
        String imageUrl = response.data['secure_url'];
        // uploadedUrl = imageUrl;
        setState(() {
          uploadedUrl = imageUrl;
        });
        return true;
      }
      return false;
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
    setState(() {
      isUpdating=true;
    });
    try {
      final profileUpdateData = ProfileUpdateRequest(
          fullName: _fullNameController.text,
          profilePicUrl: uploadedUrl,
          bio: _bioController.text,
          location: Location(country: _selectedCountry!, city: _selectedCity!));

      // Convert to JSON for API request
      final requestData = profileUpdateData.toJson();

      final response = await profileService.updateProfile(requestData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
      setState(() {
        isUpdating=false;
      });
      _fetchProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }finally{
      setState(() {
        isUpdating=false;
      });
    }
  }

  // final sharedPreferences = await SharedPreferences.getInstance();

  List<Map<String, String>> countries = [];
  List<Map<String, String>> cities = [];

  fetchCities() async {
    var cities1 = await locationService.fetchLocations();
    // for (var city in cities1) {
    //   print('City: ${city['name']}, Country Code: ${city['countryCode']}');
    // }
    setState(() {
      cities=cities1;
    });

  }

  String? _selectedCountry;
  String? _selectedCity;

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
                          Text("City"),
                          SizedBox(
                            height: 10,
                          ), cities.isEmpty ? Loading() : DropdownSearch<String>(
                              items: cities.map((city) => city['name']!.toTitleCase).toList(), // Extract city names
                            selectedItem: _selectedCity,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Select a city",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              onChanged: (selectedCity) {
                                setState(() {
                                  _selectedCity=selectedCity;
                                  _selectedCountry="EE";
                                });


                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true, // Enable search
                              ),
                            ),

                          SizedBox(
                            height: 16,
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
                    image: _image != null ?
                        DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : profile!.profile.profilePicUrl !=""? DecorationImage(
                            image: NetworkImage(
                                profile!.profile.profilePicUrl.toString()),
                            fit: BoxFit.cover,
                          ):null,
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
              Text(profile!.profile.fullName!.toTitleCase,
                  style: TextStyle(fontSize: 20)),
              Text("SwapLord", style: TextStyle(fontSize: 16)),
              Text("Rating 0", style: TextStyle(fontSize: 10)),
            ],
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

  Widget _buildSignUpButton(BuildContext context) {
    return BasicAppButton(
      height: 46,
      radius: 24,
      title: "Update",
      onPressed: isUploadingImage ? null: isUpdating ? null : () => {
        if (_formKey.currentState?.validate() ?? false) {_updateProfile()}
      },
      content: isUpdating||isUploadingImage
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
