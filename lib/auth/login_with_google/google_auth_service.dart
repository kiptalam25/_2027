import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import '../../api_client/api_client.dart';
import '../../core/services/auth_service.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signInWithGoogleAccount() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('User canceled the sign-in process.');
        return null;
      }
      print('Signed in as ${googleUser.displayName}');
      return googleUser;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  Future<void> authenticateWithBackend(GoogleSignInAuthentication googleAuth,
      Function(String idToken) onAuthenticated) async {
    try {
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        print('ID Token is null');
        return;
      }

      // Call the provided callback with the ID token
      await onAuthenticated(idToken);
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.data}');
      } else {
        print('Error during backend authentication: $e');
      }
    }
  }

  Future<void> handleGoogleSignIn(
      {required bool isSignIn,
      required Function onSuccess,
      required Function onError}) async {
    try {
      final googleUser = await signInWithGoogleAccount();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      // await authenticateWithBackend(googleAuth, (idToken) async {
      AuthService authService = AuthService(ApiClient());
      var idToken = googleAuth.idToken;
      print("Token..................." + idToken!);

      if (isSignIn) {
        // Sign-In
        final response = await authService.loginWithGoogle(idToken!);
        if (response.success) {
          onSuccess();
        } else {
          onError('Failed to sign in: ${response.message}');
        }
      } else {
        // Sign-Up
        final response = await authService.loginWithGoogle(idToken!);
        if (response.success) {
          onSuccess();
        } else {
          onError('Failed to register: ${response.message}');
        }
      }
      // });
    } catch (e) {
      onError('An error occurred: $e');
    }
  }
}
