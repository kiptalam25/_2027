import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';

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

  Future<List<Map<String, String>>> fetchSubCategories(String newValue) async {
    try {
      final response =
          await ApiClient().get(ApiConstants.subcategories + "/" + newValue);

      // Validate the response structure
      if (response.data == null || !response.data['success']) {
        throw Exception("Failed to fetch subcategories");
      }

      // Extract the 'subCategories' array
      final List<dynamic> subCategories = response.data['subCategories'];

      // Transform the data to List<Map<String, String>>
      return subCategories.map<Map<String, String>>((subCategory) {
        return {
          'id': subCategory['_id'], // '_id' is already a string
          'name': subCategory['name'], // 'name' is already a string
        };
      }).toList();
    } catch (e) {
      // Handle exceptions gracefully
      print("Error fetching subcategories: $e");
      throw e;
    }
  }
}
