import 'dart:convert';

import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';

class SwapService {
  final ApiClient apiClient;

  SwapService(this.apiClient);

  Future<ResponseModel> createSwapOffer(String offerData) async {
    try {
      final response = await apiClient.post(
        ApiConstants.swaps,
        data: offerData,
      );

      return ResponseModel.fromJson(response.data);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        // If the error is a Map, extract the error message
        final String errorMessage = e['error'] ?? "Unknown error occurred";
        return ResponseModel(success: false, message: errorMessage);
      } else if (e.toString().contains('Swap offer already exists')) {
        // If `e` is not a Map but looks like a JSON-like string
        try {
          final Map<String, dynamic> errorMap =
              jsonDecode(jsonEncode(e.toString()));
          final String errorMessage =
              errorMap['error'] ?? "Unknown error occurred";
          return ResponseModel(success: false, message: errorMessage);
        } catch (_) {
          // Fallback for invalid JSON
          return ResponseModel(
              success: false, message: "Swap offer already exists");
        }
      } else {
        // Fallback for other error types
        return ResponseModel(
            success: false, message: "An unexpected error occurred: $e");
      }
    }
  }
}
