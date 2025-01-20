// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:dio/dio.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FacebookLoginPage(),
//     );
//   }
// }
//
// class FacebookLoginPage extends StatelessWidget {
//   final Dio dio = Dio();
//
//   Future<void> loginWithFacebook() async {
//     try {
//       // Log in to Facebook
//       final LoginResult result = await FacebookAuth.instance.login();
//
//       if (result.status == LoginStatus.success) {
//         final accessToken = result.accessToken!.tokenString;
//         print(accessToken);
//         // Send token to backend
//         final response = await dio.post(
//           'https://swapify-api-c2ey.onrender.com/api/v1/users/auth/mobile/facebook',
//           data: {'accessToken': accessToken},
//         );
//
//         if (response.statusCode == 200) {
//           final token = response.data['token'];
//           print('JWT Token: $token');
//
//           // Use token to authenticate user in the app
//         }
//       } else {
//         print('Facebook Login Failed: ${result.toString()}');
//       }
//     } catch (e) {
//       print('Error logging in with Facebook: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login with Facebook')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: loginWithFacebook,
//           child: const Text('Login with Facebook'),
//         ),
//       ),
//     );
//   }
// }
