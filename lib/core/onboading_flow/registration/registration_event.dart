// lib/bloc/registration_event.dart

abstract class RegistrationEvent {}

class RegisterUser extends RegistrationEvent {
  final String fullName;
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String bio;

  // RegisterUser(
  //     this.email, this.password, this.name, this.phoneNumber, this.bio);

  // Constructor with named parameters
  RegisterUser({
    required this.fullName,
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.bio,
  });

  // Convert RegisterUser to JSON
  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
        'username': name,
        'phoneNumber': phoneNumber,
        'bio': bio,
      };

  // Create RegisterUser from JSON
  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      name: json['username'],
      phoneNumber: json['phoneNumber'],
      bio: json['bio'],
    );
  }
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
