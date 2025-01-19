import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:swapifymobile/api_constants/api_constants.dart';

// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: ['email'],
// );
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
  scopes: ['email', 'profile'],
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoggingIn = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      // Initiate Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoggingIn = false;
        });
        return;
      }

      // Get Google ID token
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        print('Failed to retrieve ID Token.');
        setState(() {
          _isLoggingIn = false;
        });
        return;
      }

      // Send the token to the backend for sign-up
      // final response = await Dio().post(
      //   'http://localhost:5000/auth/google-signup',
      //   data: {'idToken': idToken},
      // );
      final response = await Dio().post(
        ApiConstants.loginGoogle,
        data: {'idToken': idToken},
      );

      if (response.statusCode == 200) {
        // Successfully signed up
        final user = response.data['user'];
        final token = response.data['token'];
        print('User signed up: $user');
        print('Token: $token');
      } else {
        print('Sign-up failed: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      // Initialize Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('User canceled the sign-in process.');
        return;
      }

      // Authenticate and get tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final idToken = googleAuth.idToken;
      if (idToken == null) {
        setState(() {
          _isLoggingIn = false;
        });
        return;
      }

      // Send ID Token to backend using Dio
      final response = await Dio().post(
        ApiConstants.loginGoogle, // Replace with your backend endpoint
        data: jsonEncode({'idToken': idToken}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Handle response
      if (response.statusCode == 200) {
        print('Login successful: ${response.data}');
        // You can now save the token or navigate to the next screen
      } else {
        print('Failed to authenticate with backend: ${response.data}');
      }
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.data}');
      } else {
        print('Error during Google Sign-In: $e');
      }
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up with Google')),
      body: Center(
        child: _isLoggingIn
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: signInWithGoogle,
                child: Text('Sign Up with Google'),
              ),
      ),
    );
  }
}
