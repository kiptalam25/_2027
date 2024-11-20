// lib/bloc/registration_event.dart

import '../../usecases/user_profile.dart';

abstract class ProfileEvent {}

class CreateUserProfile extends ProfileEvent {
  final UserProfile userProfile;

  CreateUserProfile(this.userProfile);
}
