import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/api_constants/api_constants.dart';
import 'package:swapifymobile/core/list_item_flow/add_item_state.dart';

import '../../api_client/api_client.dart';
import 'add_item_event.dart';

class AddItemBloc extends Bloc<AddItemEvent, AddItemState> {
  final ApiClient apiClient;

  AddItemBloc(this.apiClient) : super(AddItemInitial()) {
    on<AddItemSubmit>(_onAddItemSubmit);
  }

  Future<void> _onAddItemSubmit(
      AddItemSubmit event, Emitter<AddItemState> emit) async {
    emit(AddItemLoading());
    try {
      final response = await apiClient.post(
        ApiConstants.addItem, // Replace with your endpoint
        data: event.itemData,
      );

      // Handle successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AddItemSuccess("Item created successfully!"));
      } else {
        emit(AddItemFailure("Unexpected response: ${response.statusCode}"));
      }
    } catch (e) {
      // Catch and handle errors
      emit(AddItemFailure("Failed to create item: $e"));
    }
  }
}
// Future<void> _onAddItemSubmit(
//     AddItemSubmit event, Emitter<AddItemState> emit) async {
//   emit(AddItemLoading());
//   try {
//     final response = await apiClient.post(
//       "/items", // Your endpoint
//       data: event.itemData, // Payload
//     );
//     emit(AddItemSuccess("Item created successfully!"));
//   } catch (error) {
//     emit(AddItemFailure("Failed to create item: $error"));
//   }
// }
// }
