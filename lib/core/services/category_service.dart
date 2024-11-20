import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';

class CategoryService {
  final ApiClient apiClient;

  CategoryService(this.apiClient);

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
