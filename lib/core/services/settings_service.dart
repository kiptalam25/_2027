import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';

class SettingsService {
  final ApiClient apiClient;

  SettingsService(this.apiClient);

  Future<ResponseModel> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final response = await apiClient.put(ApiConstants.editPassword, data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      });

      return ResponseModel.fromJson(response.data);
    } catch (e) {
      return ResponseModel(
          success: false, message: "Incorrect current password");

      // throw Exception("Failed to change password: $e");
    }
  }

  Future<ResponseModel> deleteAccount() async {
    try {
      final response = await apiClient.delete(ApiConstants.deleteProfile);

      return ResponseModel.fromJson(response.data);
    } catch (e) {
      return ResponseModel(success: false, message: "Failed to delete profile");
      // throw Exception("Failed to change password: $e");
    }
  }
}
