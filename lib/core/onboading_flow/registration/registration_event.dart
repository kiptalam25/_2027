// lib/bloc/registration_event.dart

abstract class RegistrationEvent {}

class RegisterUser extends RegistrationEvent {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String bio;

  RegisterUser(
      this.email, this.password, this.name, this.phoneNumber, this.bio);
}

class ValidateEmail extends RegistrationEvent {
  final String email;

  ValidateEmail(this.email);
}

class ValidatePassword extends RegistrationEvent {
  final String password;

  ValidatePassword(this.password);
}

class CheckEmailAvailability extends RegistrationEvent {
  final String email;

  CheckEmailAvailability(this.email);
}

class CheckUsernameAvailability extends RegistrationEvent {
  final String username;

  CheckUsernameAvailability(this.username);
}

class CheckPasswordStrength extends RegistrationEvent {
  final String password;

  CheckPasswordStrength(this.password);
}

class ResendVerificationEmail extends RegistrationEvent {
  final String email;

  ResendVerificationEmail(this.email);
}

class CompleteVerification extends RegistrationEvent {
  final String email;
  final String code;

  CompleteVerification(this.email, this.code);
}

class ResetRegistration extends RegistrationEvent {}
