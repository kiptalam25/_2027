import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';

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
}
