// lib/bloc/registration_state.dart

abstract class ProfileState {}

class CreateProfileInitial extends ProfileState {}

class CreateProfileLoading extends ProfileState {}

class CreateProfileSuccess extends ProfileState {
  final String message;

  CreateProfileSuccess(this.message);
}

class CreateProfileError extends ProfileState {
  final String message;

  CreateProfileError(this.message);
}
