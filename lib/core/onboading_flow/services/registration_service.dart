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
}
