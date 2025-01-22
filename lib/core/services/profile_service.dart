import 'package:swapifymobile/core/usecases/other_user_profile.dart';

import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';
import '../usecases/profile_response.dart';
import '../usecases/user_profile.dart';

class ProfileService {
  final ApiClient apiClient;

  ProfileService(this.apiClient);

  Future<UserProfileResponse?> fetchProfile() async {
    final apiClient = ApiClient();
    try {
      final response = await apiClient.get(ApiConstants.userProfile);

      // final decodedJson = jsonDecode(response.data);

      UserProfileResponse userProfileResponse =
          UserProfileResponse.fromJson(response.data);
      return userProfileResponse;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<OtherUserProfile?> fetchOtherUserProfile(String otherUserId) async {
    final apiClient = ApiClient();
    try {
      final response =
          await apiClient.get(ApiConstants.userProfile + "/${otherUserId}");

      // final decodedJson = jsonDecode(response.data);

      OtherUserProfile otherUserProfile =
          OtherUserProfile.fromJson(response.data['profile']);
      return otherUserProfile;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseModel> createProfile(UserProfile userProfile) async {
    try {
      final response = await apiClient.post(
        ApiConstants.register,
        data: userProfile.toJson(), // Pass the UserProfile object as JSON
      );

      return ResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to create profile: $e");
    }
  }

  Future<ResponseModel> updateProfile(Map<String, dynamic> requestData) async {
    try {
      final response = await apiClient.put(
        ApiConstants.updateProfile,
        data: requestData,
      );
      if (response.data["success"]) {
        return ResponseModel(
            success: response.data["success"],
            message: response.data["message"]);
      }

      return ResponseModel(success: false, message: response.data["message"]);
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }
}
