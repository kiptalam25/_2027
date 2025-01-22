import 'package:dio/dio.dart';

import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';

class PolicyService {
  Future<Response?> fetchPolicy() async {
    final apiClient = ApiClient();
    try {
      final response = await apiClient.get(
        ApiConstants.policy,
      );

      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
