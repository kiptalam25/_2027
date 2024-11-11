// lib/bloc/registration_event.dart

abstract class ProfileEvent {}

class CreateProfile extends ProfileEvent {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String bio;

  CreateProfile(
      this.email, this.password, this.name, this.phoneNumber, this.bio);
}
