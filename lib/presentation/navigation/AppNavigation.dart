// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:swapifymobile/auth/bloc/auth_bloc.dart';
// import 'package:swapifymobile/auth/bloc/auth_state.dart';
// import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
// import 'package:swapifymobile/core/onboading_flow/verification.dart';
// import 'package:swapifymobile/presentation/splash/pages/splash.dart';
//
// import '../../core/onboading_flow/login/login.dart';
// import '../../core/onboading_flow/registration/registration_bloc.dart';
// import '../../core/onboading_flow/registration/registration_state.dart';
// import '../../main/pages/home.dart';
// import '../pages/welcome.dart';
// import '../splash/block/splash_state.dart';
//
// class AppNavigator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, authState) {
//         if (authState is Unauthenticated) {
//           // Check registration status
//           context
//               .read<RegistrationBloc>()
//               .add(CheckRegistrationStatus() as RegistrationEvent);
//         } else if (authState is Authenticated) {
//           // Navigate to Home Page if authenticated
//           Navigator.of(context).pushReplacementNamed('/home');
//         }
//       },
//       builder: (context, authState) {
//         return BlocBuilder<RegistrationBloc, RegistrationState>(
//           builder: (context, regState) {
//             if (authState is Unauthenticated) {
//               // Unauthenticated logic
//               if (regState is RegistrationSuccess ||
//                   regState is VerificationComplete) {
//                 return LoginPage(
//                   currentPage: 0,
//                 );
//               } else if (regState is VerificationIncomplete) {
//                 return VerifyPage(currentPage: 3);
//               } else {
//                 return WelcomePage();
//               }
//             } else if (authState is Authenticated) {
//               return HomePage();
//             } else {
//               // Show a loading screen while checking states
//               return SplashPage();
//             }
//           },
//         );
//       },
//     );
//   }
// }
//
// class CheckRegistrationStatus {}
//
// class VerificationIncomplete {}
