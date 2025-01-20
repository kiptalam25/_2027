// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:convert';
//
// class TwitterLoginPage extends StatefulWidget {
//   @override
//   _TwitterLoginPageState createState() => _TwitterLoginPageState();
// }
//
// class _TwitterLoginPageState extends State<TwitterLoginPage> {
//   final _storage = FlutterSecureStorage();
//
//   Future<void> loginWithTwitter() async {
//     final String backendUrl =
//         'https://swapify-api-c2ey.onrender.com/api/v1/users/auth/mobile/twitter';
//
//     try {
//       // Step 1: Open Twitter login page in the browser
//       final response = await http.post(Uri.parse(backendUrl));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final String jwtToken = data['token'];
//
//         // Store the token securely
//         await _storage.write(key: 'jwt', value: jwtToken);
//
//         // Use profile data if needed
//         final profile = data['profile'];
//         print('User logged in: $profile');
//
//         // Navigate to home or any other page
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         print('Error during Twitter login: ${response.body}');
//       }
//     } catch (error) {
//       print('Error during Twitter login: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Twitter Login')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: loginWithTwitter,
//           child: Text('Login with Twitter'),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:twitter_login/twitter_login.dart';
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
//       home: TwitterLoginPage(),
//     );
//   }
// }
//
// class TwitterLoginPage extends StatelessWidget {
//   Future<void> loginWithTwitter() async {
//     // Configure Twitter Login
//     final twitterLogin = TwitterLogin(
//       apiKey: 'your_twitter_api_key',
//       apiSecretKey: 'your_twitter_api_secret',
//       redirectURI: 'your_app_redirect_uri', // Example: 'myapp://'
//     );
//
//     // Trigger the login flow
//     final authResult = await twitterLogin.login();
//
//     switch (authResult.status) {
//       case TwitterLoginStatus.loggedIn:
//         final session = authResult.authToken;
//         final secret = authResult.authTokenSecret;
//
//         // Use session and secret as needed
//         print('Login successful! Token: $session, Secret: $secret');
//         break;
//
//       case TwitterLoginStatus.cancelledByUser:
//         print('Login cancelled by user');
//         break;
//
//       case TwitterLoginStatus.error:
//         print('Login error: ${authResult.errorMessage}');
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login with Twitter')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: loginWithTwitter,
//           child: const Text('Login with X (Twitter)'),
//         ),
//       ),
//     );
//   }
// }
