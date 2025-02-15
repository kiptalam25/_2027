import 'package:swapifymobile/api_client/api_client.dart';
import 'package:swapifymobile/core/usecases/SingleItem.dart';

import '../../api_constants/api_constants.dart';

class LocationService{
  final ApiClient apiClient;

  LocationService(this.apiClient);

  Future<List<Map<String, String>>> fetchLocations() async {
    try {
      final response = await apiClient.get(ApiConstants.cities);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];

        // Transform the data to List<Map<String, String>>
        return data.map<Map<String, String>>((city) {
          return {
            'name': city['name'],
            'countryCode': city['countryCode'],
          };
        }).toList();
      } else {
        throw Exception(
            'Failed to fetch Cities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
        'Failed to fetch Cities. Error $e',
      );
    }
  }
}