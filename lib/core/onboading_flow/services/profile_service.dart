import '../../../api_client/api_client.dart';
import '../../../api_constants/api_constants.dart';
import '../../../auth/models/response_model.dart';
import '../../usecases/user_profile.dart';

class ProfileService {
  final ApiClient apiClient;

  ProfileService(this.apiClient);

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
}
