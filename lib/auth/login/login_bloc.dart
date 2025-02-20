import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/core/services/sharedpreference_service.dart';
import 'package:swapifymobile/core/usecases/SingleItem.dart';
import 'package:swapifymobile/core/usecases/profile_data.dart';

import '../../core/services/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;
  final SharedPreferences sharedPreferences;

  LoginBloc(this.authService, this.sharedPreferences) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<CheckToken>(_onCheckToken);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    sharedPreferences.clear();
    try {
      print("............................runs here");
      int statusCode=500;

      final result =
          await authService.login(event.email, event.password);
      if (result['success']) {
        var responseData = result['data'];
        if(responseData['success']){
           statusCode=result['statusCode'];
           print("Success................................................");
           await sharedPreferences.setString('token', responseData['token']);
               await sharedPreferences.setString('username', responseData['username']);
               await sharedPreferences.setString('userId', responseData['userId']);
               print("......................Truing...To..Save....profile.....");
               if (responseData['profileData'] != null) {
                 print("...........................Saving profile.....");
                await SharedPreferencesService.setProfileData(new ProfileData.fromJson(responseData['profileData']));

               }
          emit(LoginSuccess("Successfully Login"));
          // emit(LoginFailure(201,"Error Login"));
        }else{
          // result['data']; output:  data: {success: false, error: User not found}}

          String errorMessage = result['data']['data']?['error'] ??
              result['message'] ??
              'Unknown error occurred';
          print(errorMessage);

          print("Error: $errorMessage (Code: ${result['statusCode']})");
           statusCode=result['statusCode'];

          emit(LoginFailure(statusCode,errorMessage));
        }
      } else {
         statusCode=result['statusCode'];
        emit(LoginFailure(statusCode,"Internal Server Error"));
        // Show error message based on statusCode
      }

      // if (response is LoginResponse) {
      //   if (response.success) {
      //     await sharedPreferences.setString('token', response.token!);
      //     await sharedPreferences.setString('username', response.username!);
      //     await sharedPreferences.setString('userId', response.userId!);
      //     print("...........................Saving profile.....");
      //     if (response.profileData != null) {
      //       SharedPreferencesService.setProfileData(response.profileData!);
      //     }
      //
      //     emit(LoginSuccess(response.token!));
      //   } else {
      //     // Handle failed login with a message
      //     emit(LoginFailure("Login Failed!"));
      //   }
      // } else if (response is LoginResponseModel) {
      //   // Handle unexpected response type
      //   emit(LoginFailure(response.message));
      // }

      // if (response.success) {
      //   LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      //   await sharedPreferences.setString('token', response.token!);
      //   await sharedPreferences.setString('username', response.username!);
      //   await sharedPreferences.setString('userId', response.userId!);
      //   await sharedPreferences.setString('profileData', response.profileData!);
      //   emit(LoginSuccess(response.token!));
      // } else {
      //   emit(LoginFailure(response.message));
      // }
    } catch (e) {
      print("Logic Error: "+e.toString());
      emit(LoginFailure(500,e.toString()));
    }
  }

  // Future<void> saveProfileData(Map<String, dynamic> profileData) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // Convert profileData to a JSON string
  //   String profileJson = jsonEncode(profileData);
  //   await prefs.setString('profileData', profileJson);
  // }

  void _onCheckToken(CheckToken event, Emitter<LoginState> emit) async {
    final token = sharedPreferences.getString('token');
    if (token != null) {
      emit(LoginSuccess(token));
    } else {
      emit(LoginInitial());
    }
  }
}
