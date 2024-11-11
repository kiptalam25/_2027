// // auth_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../core/onboading_flow/registration/registration_bloc.dart';
// import '../../core/onboading_flow/registration/registration_state.dart';
// import 'auth_event.dart';
// import 'auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final RegistrationBloc registrationBloc;
//
//   AuthBloc({required this.registrationBloc}) : super(Unauthenticated()) {
//     // Start the app with an initial check
//     on<AppStarted>((event, emit) {
//       _checkAuthState();
//     });
//
//     // Listen to registration state changes
//     registrationBloc.stream.listen((registrationState) {
//       if (registrationState is RegistrationSuccess) {
//         // Check if verification is complete after successful registration
//         bool isVerified = false; // Replace with actual verification check
//         if (isVerified) {
//           emit(Authenticated());
//         } else {
//           emit(IncompleteRegistration(
//               RegistrationSuccess("Registered but not verified")));
//         }
//       } else if (registrationState is VerificationComplete) {
//         emit(Authenticated());
//       } else if (registrationState is RegistrationInitial) {
//         emit(Unregistered());
//       }
//     });
//   }
//
//   void _checkAuthState() {
//     // Mock authentication check - replace with real logic
//     bool isAuthenticated = false;
//     bool isRegistered = true;
//     if (isAuthenticated) {
//       emit(Authenticated());
//     } else if (isRegistered) {
//       emit(Unregistered());
//     } else {
//       emit(Unauthenticated());
//     }
//   }
// }
