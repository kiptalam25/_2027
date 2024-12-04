import 'package:equatable/equatable.dart';

abstract class UpdateItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateItemInitial extends UpdateItemState {}

class UpdateItemLoading extends UpdateItemState {}

class UpdateItemSuccess extends UpdateItemState {
  final String message;
  final String itemId;

  UpdateItemSuccess(this.message, this.itemId);

  @override
  List<Object?> get props => [message];
}

class UpdateItemFailure extends UpdateItemState {
  final String error;

  UpdateItemFailure(this.error);

  @override
  List<Object?> get props => [error];
}
