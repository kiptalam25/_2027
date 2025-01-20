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
}
