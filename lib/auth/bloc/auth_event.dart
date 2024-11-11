// auth_event.dart
abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginSuccess extends AuthEvent {}

class Logout extends AuthEvent {}

class RegistrationIncomplete extends AuthEvent {
  final int step;
  RegistrationIncomplete(this.step);
}

class CompleteRegistration extends AuthEvent {}
