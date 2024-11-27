import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleLoginPage extends StatefulWidget {
  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  final String backendBaseUrl = "http://192.168.100.4:8080";
  Future<void> initiateGoogleLogin() async {
    final googleLoginUrl = "$backendBaseUrl/auth/google";
    try {
      if (await canLaunch(googleLoginUrl)) {
        await launch(googleLoginUrl);
      } else {
        throw 'Could not launch $googleLoginUrl';
      }
    } catch (e) {
      print("Error launching URL: $e");
    }
  }

  // Future<void> initiateGoogleLogin() async {
  //   final googleLoginUrl = "$backendBaseUrl/auth/google";
  //
  //   // Launch the Google Login URL
  //   if (await canLaunch(googleLoginUrl)) {
  //     await launch(googleLoginUrl);
  //   } else {
  //     throw 'Could not launch $googleLoginUrl';
  //   }
  // }

  Future<void> fetchJwtFromCallback(String callbackUrl) async {
    try {
      // Extract the authorization code from the callback URL
      final Uri uri = Uri.parse(callbackUrl);
      final String? code = uri.queryParameters['code'];

      if (code != null) {
        // Exchange the code for a JWT
        final Dio dio = Dio();
        final response = await dio
            .get("$backendBaseUrl/auth/google/callback", queryParameters: {
          'code': code,
        });

        if (response.statusCode == 200) {
          // Store the JWT
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("jwt", response.data);

          // Navigate to the main screen
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          throw Exception("Failed to log in");
        }
      } else {
        throw Exception("No authorization code found in callback URL");
      }
    } catch (e) {
      print("Error during Google Login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: initiateGoogleLogin,
          child: Text("Login with Google"),
        ),
      ),
    );
  }
}
