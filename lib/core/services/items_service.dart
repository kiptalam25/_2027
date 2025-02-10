import 'package:dio/src/response.dart';

import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';
import '../usecases/SingleItem.dart';
import '../usecases/item.dart';

class ItemsService {
  final ApiClient apiClient;

  ItemsService(this.apiClient);

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

  Future<Response?> fetchItems(String keyword) async {
    final apiClient = ApiClient();
    try {
      final response = await apiClient.get(
        ApiConstants.searchItems,
        queryParameters: {
          'keyword': keyword,
          'category': '',
          'condition': '',
          'sort': 'createdAt',
          'page': 1,
          'limit': 50,
          'order': 'desc', // or 'desc'
        },
      );

      print('Response data: ${response.data}');
      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Response?> fetchOwnItems(String keyword) async {
    final apiClient = ApiClient();
    try {
      final response = await apiClient.get(
        ApiConstants.items,
        queryParameters: {
          'keyword': keyword,
          'category': '',
          'condition': '',
          'sort': 'createdAt',
          'page': 1,
          'limit': 50,
          'order': 'desc', // or 'desc'
        },
      );

      print('Response data: ${response.data}');
      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseModel> updateItem(String itemData, String itemId) async {
    try {
      final response = await apiClient.put(
        ApiConstants.items + "/$itemId",
        data: itemData,
      );

      return ResponseModel.fromJson(response.data);
    } catch (e) {
      // return ResponseModel(success: , message: message)
      throw Exception("Failed to Update Item: $e");
    }
  }

  Future<List<Map<String, String>>> fetchCategories() async {
    try {
      final response = await ApiClient()
          .get(ApiConstants.categories); // Replace with your API path
      final List<dynamic> data = response.data;

      // Transform the data to List<Map<String, String>>
      return data.map<Map<String, String>>((category) {
        return {
          'id': category['_id'].toString(), // Ensure ID is a string
          'name': category['name'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<SingleItem> fetchItem(String itemId) async {
    try {
      final response = await apiClient.get(ApiConstants.items + "/$itemId");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['item'] != null) {
          return SingleItem.fromJson(data['item']);
        } else {
          throw Exception('Invalid item structure');
        }
        // final responseData = response.data;
        // return Item.fromJson(responseData['item']);
      } else {
        throw Exception(
            'Failed to fetch item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
        'Failed to fetch item. Error $e',
      );
    }
  }

  Future<ResponseModel> deleteItem(String itemId) async {
    try {
      final response = await apiClient.delete(ApiConstants.items + "/$itemId");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return ResponseModel.fromJson(response.data);
        } else {
          return ResponseModel(
              success: false,
              message: "${response.statusCode}: Failed to delete");
          // throw Exception('Invalid item structure');
        }
        // final responseData = response.data;
        // return Item.fromJson(responseData['item']);
      } else {
        return ResponseModel(
            success: false,
            message: "${response.statusCode}: Failed to delete");
      }
    } catch (e) {
      return ResponseModel(
          success: false, message: "Internal error Failed to delete: ${e}");
    }
  }
}
