import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginPage extends StatefulWidget {
  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  String? _accessToken;

  Future<void> _loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Access the token from the AccessToken object
        final AccessToken? accessToken = result.accessToken;
        setState(() {
          _accessToken = accessToken?.toJson()['token'];
        });

        // Optional: Fetch user profile data
        final userData = await FacebookAuth.instance.getUserData();
        print("User Data: $userData");

        // Send the token to your backend
        if (_accessToken != null) {
          await _sendTokenToBackend(_accessToken!);
        }
      } else if (result.status == LoginStatus.cancelled) {
        print("Login cancelled by user");
      } else if (result.status == LoginStatus.failed) {
        print("Login failed: ${result.message}");
      }
    } catch (e) {
      print("Error during Facebook login: $e");
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    // Replace this with an API call to your backend to handle authentication
    print("Sending Facebook token to backend: $token");
    // Example: Send the token to your backend using Dio or http
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Facebook Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _loginWithFacebook,
              child: const Text("Login with Facebook"),
            ),
            if (_accessToken != null) Text("Access Token: $_accessToken"),
          ],
        ),
      ),
    );
  }
}
