import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/api_constants/api_constants.dart';
import 'package:swapifymobile/core/list_item_flow/bloc/add_item_state.dart';
import 'package:swapifymobile/core/list_item_flow/bloc/update_item_event.dart';
import 'package:swapifymobile/core/list_item_flow/bloc/update_item_state.dart';

import '../../../api_client/api_client.dart';
import 'add_item_event.dart';

class UpdateItemBloc extends Bloc<UpdateItemEvent, UpdateItemState> {
  final ApiClient apiClient;

  UpdateItemBloc(this.apiClient) : super(UpdateItemInitial()) {
    on<UpdateItemSubmit>(_onUpdateItemSubmit);
  }

  Future<void> _onUpdateItemSubmit(
      UpdateItemSubmit event, Emitter<UpdateItemState> emit) async {
    emit(UpdateItemLoading());
    try {
      final response = await apiClient.put(
        ApiConstants.items + "/${event.id}", // Replace with your endpoint
        data: event.itemData,
      );
      final responseData = response.data;

      // Handle successful response
      if (responseData['success']) {
        final message = responseData['message'] ?? 'Item Updated successfully!';
        final itemId = responseData['item']['_id'];
        emit(UpdateItemSuccess(message, itemId));
      } else {
        emit(UpdateItemFailure("Unexpected response: ${response.statusCode}"
            " ${responseData['message']}"));
      }
    } catch (e) {
      emit(UpdateItemFailure("Failed to create item: "));
    }
  }
}
