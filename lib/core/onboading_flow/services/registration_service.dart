import 'package:dio/src/response.dart';
import 'package:swapifymobile/auth/models/response_model.dart';

import '../../../api_client/api_client.dart';
import '../../../api_constants/api_constants.dart';
import '../../../auth/services/auth_service.dart';

class RegistrationService {
  final ApiClient apiClient;

  RegistrationService(this.apiClient);

  Future fetchItemsFromApi() async {
    try {
      // final response = await Dio().get(ApiConstants.categories);
      final response = await apiClient.get(ApiConstants.categories);
      if (response.statusCode == 200) {
        return response.data.map<Map<String, String>>((item) => {
              'id': item['_id'].toString(),
              'name': item['name'].toString(),
            });
        // setState(() {
        //   items = response.data
        //       .map<Map<String, String>>((item) => {
        //     'id': item['_id'].toString(),
        //     'name': item['name'].toString(),
        //   })
        //       .toList();
        // });
      }
      print('Fetch Categories Status code not 200:');
    } catch (e) {
      // return "Failed";
      print('Failed to load items: $e');
    }
  }

  Future<EmailCheckResponse> checkEmail(String username) async {
    final String path = '?email=$username'; // Adjust the endpoint as necessary
    try {
      final response = await apiClient.get(ApiConstants.checkEmail + path);

      // Parse the response into a UsernameCheckResponse object
      final data = EmailCheckResponse.fromJson(response.data);

      return data;
    } catch (e) {
      if (e.toString().contains("Email already exists")) {
        return EmailCheckResponse(
            success: true, available: false, message: "Email already exists");
      }
      return EmailCheckResponse(
          success: false, available: false, message: e.toString());
      print('Error checking username: $e');
      rethrow;
    }
  }

  Future<ResponseModel> updateSwapInterests(String swapCategoriesAsJson) async {
    final response = await apiClient.post(ApiConstants.updateSwapInterests,
        data: swapCategoriesAsJson);
    return ResponseModel.fromJson(response.data);
  }
}

class UsernameCheckResponse {
  final bool success;
  final bool available;
  final String message;
  // final List<String> suggestions;

  UsernameCheckResponse({
    required this.success,
    required this.available,
    required this.message,
    // required this.suggestions,
  });

  // Factory constructor to create an instance from JSON
  factory UsernameCheckResponse.fromJson(Map<String, dynamic> json) {
    return UsernameCheckResponse(
      success: json['success'],
      available: json['available'],
      message: json['message'],
      // suggestions: List<String>.from(json['suggestions'] ?? []),
    );
  }
}

class EmailCheckResponse {
  final bool success;
  final bool available;
  final String message;
  // final List<String> suggestions;

  EmailCheckResponse({
    required this.success,
    required this.available,
    required this.message,
    // required this.suggestions,
  });

  // Factory constructor to create an instance from JSON
  factory EmailCheckResponse.fromJson(Map<String, dynamic> json) {
    return EmailCheckResponse(
      success: json['success'],
      available: json['available'],
      message: json['message'],
      // suggestions: List<String>.from(json['suggestions'] ?? []),
    );
  }
}
