// lib/bloc/registration_state.dart

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class VerificationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String message;

  RegistrationSuccess(this.message);
}

class RegistrationError extends RegistrationState {
  final String message;

  RegistrationError(this.message);
}

class EmailAvailable extends RegistrationState {}

class EmailInUse extends RegistrationState {}

class WeakPassword extends RegistrationState {}

class MediumPassword extends RegistrationState {}

class StrongPassword extends RegistrationState {}

class VerificationEmailSent extends RegistrationState {}

class ResendingVerificationEmail extends RegistrationState {}

class VerificationComplete extends RegistrationState {}
