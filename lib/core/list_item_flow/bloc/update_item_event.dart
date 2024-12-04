import 'package:equatable/equatable.dart';

abstract class UpdateItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateItemSubmit extends UpdateItemEvent {
  final Map<String, dynamic> itemData;
  final String id;
  // String itemData;
  UpdateItemSubmit(
    this.itemData,
    this.id,
  );

  @override
  List<Object?> get props => [itemData];
}
