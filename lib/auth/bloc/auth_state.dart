// auth_state.dart
import 'package:swapifymobile/core/onboading_flow/registration/registration_state.dart';

abstract class AuthState {}

class Unauthenticated extends AuthState {}

// class Authenticated extends AuthState {}

class Unregistered extends AuthState {}

// class IncompleteRegistration extends AuthState {
//   final RegistrationState registrationState;
//
//   IncompleteRegistration(this.registrationState);
// }
