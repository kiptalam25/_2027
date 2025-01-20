import 'package:dio/dio.dart';

import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';

class ChatService {
  final ApiClient apiClient;

  ChatService(this.apiClient);

  Future<Response?> fetchConversations() async {
    final apiClient = ApiClient();
    try {
      final response = await apiClient.get(
        ApiConstants.conversations,
        // queryParameters: {
        //   'keyword': keyword,
        //   'category': '',
        //   'condition': '',
        //   'sort': 'createdAt',
        //   'page': 1,
        //   'limit': 50,
        //   'order': 'desc', // or 'desc'
        // },
      );

      print('Response data: ${response.data}');
      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseModel> addItem(String itemData) async {
    try {
      final response = await apiClient.post(
        ApiConstants.addItem,
        data: itemData,
      );

      return ResponseModel.fromJson(response.data);
    } catch (e) {
      // return ResponseModel(success: , message: message)
      throw Exception("Failed to create profile: $e");
    }
  }

  fetchChat(exchangeId) async {
    return await apiClient.get(
      ApiConstants.conversations + "/" + exchangeId,
    );
  }

  sendMessage(String message) async {
    return await apiClient.post(ApiConstants.sendMessage, data: message);
  }
}
