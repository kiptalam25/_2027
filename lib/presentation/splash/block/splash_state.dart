import '../../../auth/bloc/auth_state.dart';
import '../../../core/onboading_flow/registration/registration_state.dart';

abstract class SplashState {}

class DisplaySplash extends SplashState {}

class Authenticated extends SplashState {}

class UnAuthenticated extends SplashState {}

class IncompleteRegistration extends AuthState {
  final RegistrationState registrationState;
  IncompleteRegistration(this.registrationState);
}
