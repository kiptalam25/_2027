import 'dart:convert';

import 'package:dio/dio.dart';

import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/response_model.dart';

class TradeService {
  final ApiClient apiClient;

  TradeService(this.apiClient);

  Future<Response?> createDonationRequest(String offerData) async {
    try {
      final response = await apiClient.post(
        ApiConstants.donation,
        data: offerData,
      );

      return response;
    } catch (e) {
      print(e);
    }
  }

    Future<Response?> createSwapOffer(String offerData) async {
      try {
        final response = await apiClient.post(
          ApiConstants.swaps,
          data: offerData,
        );

        return response;
      } catch (e) {
        print("Error: ......................");
        print(e);
        return null;
      }

  }
}
