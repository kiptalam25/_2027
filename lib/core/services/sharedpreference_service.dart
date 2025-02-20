import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../usecases/profile_data.dart';

class SharedPreferencesService {
  static Future<ProfileData?> getProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileJson = prefs.getString('profileData');

    if (profileJson != null) {
      return ProfileData.fromJson(jsonDecode(profileJson));
    }
    return null;
  }


  static Future<void> setProfileData(ProfileData profileData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove existing profile data
    await prefs.remove('profileData');

    // Handle case where location.city is empty
    if (profileData.location?.city?.isEmpty ?? true) {
      profileData.location = null;
    }

    // Convert profile data to JSON and save it
    final String profileDataJson = jsonEncode(profileData.toJson());
    await prefs.setString('profileData', profileDataJson);
  }



  static Future<void> setHomeFilter(Map<String,dynamic> homeFilter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final filterData = jsonEncode(homeFilter);
    await prefs.setString('homeFilter', filterData);
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }


}
