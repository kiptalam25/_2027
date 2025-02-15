import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/core/services/sharedpreference_service.dart';

import '../../api_client/api_client.dart';
import '../../api_constants/api_constants.dart';
import '../../auth/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../usecases/SingleItem.dart';
import '../usecases/profile_data.dart';

class AuthService {
  final ApiClient apiClient;
AuthService(this.apiClient);


  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {
          'email': username,
          'password': password,
        },
      );

      // If login is successful, return response data
      return {
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      // Handle Dio errors (network, timeout, bad request, etc.)
      int statusCode = e.response?.statusCode ?? 500;
      String errorMessage = 'An unexpected error occurred';

      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server took too long to respond';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = 'Invalid response from server';
      }

      return {
        'success': false,
        'message': errorMessage,
        'statusCode': statusCode,
      };
    } catch (e) {
      // Catch any other unexpected errors
      return {
        'success': false,
        'message': 'Something went wrong',
        'statusCode': 500,
      };
    }
  }


  // Future<Object> login(String username, String password) async {
  //   try {
  //     final response = await apiClient.post(ApiConstants.login, data: {
  //       'email': username,
  //       'password': password,
  //     });
  //     print("Response --------------------------------------------------------");
  //       print(response.toString());
  //     if (response.data['success']) {
  //       // return loginResponse;
  //
  //       return LoginResponse.fromJson(response.data);
  //       // return LoginResponse(
  //       //   success: true,
  //       //   message: response.data['message'],
  //       //   username: response.data['username'],
  //       //   userId: response.data['userId'],
  //       //   token: response.data['token'],
  //       // );
  //     } else if(!response.data['success']){
  //       return LoginResponseModel(
  //           success: false, message: response.data['message']);
  //     }else{
  //       return LoginResponseModel(
  //           success: false, message: "Failed to login");
  //     }
  //   } catch (e) {
  //     return LoginResponseModel(success: false, message: e.toString());
  //   }
  // }

  Future<LoginResponseModel> loginWithGoogle(String idToken) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final response = await apiClient.post(ApiConstants.loginGoogle, data: {
        'idToken': idToken,
      });

      //Response
   /*       {
        "success": true,
    "message": "User logged in successfully",
    "username": "Kiptalam Joseph",
    "userId": "679b7dfd83760e042005c2b7",
    "email": "kiptalamjoseph@gmail.com",
    "fullName": "Kiptalam Joseph",
    "profilePicUrl": "https://lh3.googleusercontent.com/a/ACg8ocJeyQl7iuIJ1ZflxZOlA8BAFJO2qAiukaHl0oJd6G3APHTijAif=s96-c",
    "profileData": {
    "location": {
    "country": "Estonia",
    "city": "city1"
  },
    "interests": {
    "categoryId": ["672c94821c9af885908ce3e3"],
    "city": []
  },
    "_id": "679b7dfd3bf88fb58d6930e5",
    "userId": "679b7dfd83760e042005c2b7",
    "fullName": "Kiptalam Joseph",
    "profilePicUrl": "https://lh3.googleusercontent.com/a/ACg8ocJeyQl7iuIJ1ZflxZOlA8BAFJO2qAiukaHl0oJd6G3APHTijAif=s96-c",
    "listedItemCount": 0,
    "completedSwapCount": 0,
    "completedDonationCount": 0,
    "createdAt": "2025-01-30T13:26:21.797Z",
    "__v": 0,
    "bio": "No bio available hdjdkskskhdjdjdjsnd r r. r ff f f",
    "updatedAt": "2025-02-03T11:34:36.183Z"
  },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NzliN2RmZDgzNzYwZTA0MjAwNWMyYjciLCJlbWFpbCI6ImtpcHRhbGFtam9zZXBoQGdtYWlsLmNvbSIsImF1dGhNZXRob2QiOiJnb29nbGUiLCJpYXQiOjE3Mzg1ODMyNTQsImV4..."
  }

    */


    if (response.data['success']) {
        await sharedPreferences.setString('token', response.data['token']);
        await sharedPreferences.setString(
            'username', response.data['username']);
        await sharedPreferences.setString('userId', response.data['userId']);
        print(response.data.toString());
        SharedPreferencesService.setProfileData(
            LoginResponse.fromJson(response.data).profileData!

            // ProfileData(
            // fullName: response.data['username'],
            // bio: "",
            // createdAt: "",
            // id: "",
            // profilePicUrl: "",
            // userId: response.data['userId'],
            // interests: Interests(),
            // version: 1,
            // location: Location())
        );

        // if (response.profileData != null) {
        //   final profileDataJson = jsonEncode(response.profileData!.toJson());
        //   await sharedPreferences.setString('profileData', profileDataJson);
        // }
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
    }
     catch (e) {
      return ResponseModel(
          success: false, message: 'Unexpected error: ${e.toString()}');
    }
  }

  // registerWithGoogle(String idToken) {}

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
