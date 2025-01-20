import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/common/widgets/app_navigator.dart';
import 'package:swapifymobile/core/profile/profile_event.dart';
import 'package:swapifymobile/core/welcome/splash/pages/welcome.dart';

import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../usecases/SingleItem.dart';
import '../usecases/profile_data.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<Object> login(String username, String password) async {
    try {
      final response = await apiClient.post(ApiConstants.login, data: {
        'email': username,
        'password': password,
      });

      if (response.data['success']) {
        // return loginResponse;
        return LoginResponse.fromJson(response.data);
        // return LoginResponse(
        //   success: true,
        //   message: response.data['message'],
        //   username: response.data['username'],
        //   userId: response.data['userId'],
        //   token: response.data['token'],
        // );
      } else {
        return LoginResponseModel(
            success: false, message: response.data['message']);
      }
    } catch (e) {
      return LoginResponseModel(success: false, message: e.toString());
    }
  }

  Future<LoginResponseModel> loginWithGoogle(String idToken) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final response = await apiClient.post(ApiConstants.loginGoogle, data: {
        'idToken': idToken,
      });

      if (response.data['success']) {
        await sharedPreferences.setString('token', response.data['token']);
        await sharedPreferences.setString(
            'username', response.data['username']);
        await sharedPreferences.setString('userId', response.data['userId']);
        return LoginResponseModel(
          success: true,
          message: response.data['message'],
          username: response.data['username'],
          userId: response.data['userId'],
          token: response.data['token'],
        );
      } else {
        print("Error Message:..........." + response.data['error']);

        return LoginResponseModel(
            success: false, message: response.data['error']);
      }
    } catch (e) {
      print("Exception Message:..........." + e.toString());
      return LoginResponseModel(success: false, message: e.toString());
    }
  }
  // Future<UserModel> login(String email, String password) async {
  //   final response = await apiClient.post(ApiConstants.login, data: {
  //     'email': email,
  //     'password': password,
  //   });
  //   return UserModel.fromJson(response.data);
  // }

  Future<bool> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    return true;
    // final response = await apiClient.post(ApiConstants.logout);
    // return ResponseModel.fromJson(response.data);
  }

  Future<ResponseModel> register(String email, String password, String name,
      phone, fullName, profilePicUrl, bio) async {
    final response = await apiClient.post(ApiConstants.register, data: {
      'email': email,
      'password': password,
      'username': name,
      'phoneNumber': phone,
      'fullName': fullName,
      'profilePicUrl': profilePicUrl,
      'bio': bio
    });
    return ResponseModel.fromJson(response.data);
  }

  /// Check if an email is available
  Future<bool> checkEmail(String email) async {
    final response = await apiClient.post(ApiConstants.checkemail, data: {
      'email': email,
    });
    return UserModel.fromJson(response.data) as bool;
    // final url = Uri.parse('$_baseUrl/check-email');
    // final response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({'email': email}),
    // );
    //
    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   return data['isAvailable'] as bool;
    // } else {
    //   throw Exception('Error checking email availability');
  }

  /// Check if a username is available
  Future<bool> checkUsername(String username) async {
    final url = Uri.parse(ApiConstants.checkUsername + '?username=$username');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isAvailable'] as bool;
    } else {
      throw Exception('Error checking username availability');
    }
  }

  /// Resend the verification email
  Future<ResponseModel> resendVerificationEmail(String email) async {
    try {
      final response =
          await apiClient.post(ApiConstants.initiateVerification, data: {
        'email': email,
      });
      if (response.data['success']) {
        return ResponseModel(
          success: true,
          message: response.data['message'],
        );
      } else {
        return ResponseModel(success: false, message: response.data['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: 'An error occurred');
    }
  }

  Future<ResponseModel> completeVerification(String email, String code) async {
    try {
      final response = await apiClient.put(
        ApiConstants.completeVerification,
        data: {'email': email, 'verificationCode': code},
      );

      if (response.data['success']) {
        return ResponseModel(
          success: true,
          message: response.data['message'],
        );
      } else {
        return ResponseModel(success: false, message: response.data['message']);
      }
    } on ApiException catch (e) {
      // Extract the error message using a regular expression
      final errorPattern = RegExp(
          r'error:\s*([^}]+)'); // Regex to capture the text after 'error:'
      final match = errorPattern.firstMatch(e.message);

      // Extracted error message or default to the whole message if parsing fails
      final errorMessage = match != null ? match.group(1)?.trim() : e.message;

      return ResponseModel(
          success: false, message: errorMessage ?? 'Unknown error');
    } catch (e) {
      return ResponseModel(
          success: false, message: 'Unexpected error: ${e.toString()}');
    }
  }

  registerWithGoogle(String idToken) {}

//   Future<ResponseModel> completeVerification(String email, String code) async {
//     try {
//       final response = await apiClient.put(ApiConstants.completeVerification,
//           data: {'email': email, 'code': code});
//       if (response.data['success']) {
//         return ResponseModel(
//           success: true,
//           message: response.data['message'],
//         );
//       } else if (!response.data['success']) {
//         return ResponseModel(success: false, message: response.data['message']);
//       } else {
//         return ResponseModel(success: false, message: response.data['message']);
//       }
//     } catch (e) {
//       return ResponseModel(success: false, message: e.toString());
//     }
//   }
}

class LoginResponse {
  final bool success;
  final String? message;
  final String? username;
  final String? userId;
  final String? email;
  final String? fullName;
  final ProfileData? profileData;
  final String? token;

  LoginResponse({
    required this.success,
    this.message,
    this.username,
    this.userId,
    this.email,
    this.fullName,
    this.profileData,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      username: json['username'],
      userId: json['userId'],
      email: json['email'],
      fullName: json['fullName'],
      profileData: json['profileData'] != null
          ? ProfileData.fromJson(json['profileData'])
          : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'username': username,
      'userId': userId,
      'email': email,
      'fullName': fullName,
      'profileData': profileData?.toJson(),
      'token': token,
    };
  }
}

// class Location {
//   final String? country;
//   final String? city;
//
//   Location({this.country, this.city});
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       country: json['country'],
//       city: json['city'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'country': country,
//       'city': city,
//     };
//   }
// }

class Interests {
  final List<String>? categoryId;
  final List<String>? city;

  Interests({this.categoryId, this.city});

  factory Interests.fromJson(Map<String, dynamic> json) {
    return Interests(
      categoryId: json['categoryId'] != null
          ? List<String>.from(json['categoryId'])
          : [],
      city: json['city'] != null ? List<String>.from(json['city']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'city': city,
    };
  }
}

// class Location {
//   final String? country;
//   final String? city;
//
//   Location({
//     required this.country,
//     required this.city,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       country: json['country'],
//       city: json['city'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'country': country,
//       'city': city,
//     };
//   }
// }

class LoginResponseModel {
  final bool success;
  final String message;
  final String? username;
  final String? userId;
  final String? token;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.username,
    this.userId,
    this.token,
  });
}
