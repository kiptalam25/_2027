import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';

import '../../api_constants/api_constants.dart';
import '../../core/services/auth_service.dart';

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: ApiConstants.googleServerClientId,
    scopes: ['email'],
  );
  final AuthService authService;

  GoogleSignInHelper(this.authService);

  Future<LoginResponseModel> signInWithGoogle() async {
    try {
      // Start Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Sign-In was canceled
        return LoginResponseModel(
          success: false,
          message: 'User canceled the sign-in process.',
        );
      }

      print('Signed in as ${googleUser.displayName}');

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        return LoginResponseModel(
          success: false,
          message: 'Failed to retrieve ID token from Google.',
        );
      }

      // Send ID token to backend
      final response = await authService.loginWithGoogle(idToken);

      // Return the result
      return response;
    } catch (e) {
      if (e is DioException) {
        return LoginResponseModel(
          success: false,
          message: 'DioError: ${e.response?.data}',
        );
      } else if (e is PlatformException) {
        return LoginResponseModel(
          success: false,
          message: 'PlatformException: ${e.message} (Code: ${e.code})',
        );
      } else {
        return LoginResponseModel(
          success: false,
          message: 'Error during Google Sign-In: $e',
        );
      }
    }
  }
}

// Helper class to represent the authentication result
class AuthResult {
  final bool success;
  final String message;

  AuthResult({required this.success, required this.message});
}
