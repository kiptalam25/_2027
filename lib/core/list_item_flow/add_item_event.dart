import 'package:equatable/equatable.dart';

abstract class AddItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddItemSubmit extends AddItemEvent {
  final Map<String, dynamic> itemData; // e.g., JSON payload
  // String itemData;
  AddItemSubmit(this.itemData);

  @override
  List<Object?> get props => [itemData];
}
