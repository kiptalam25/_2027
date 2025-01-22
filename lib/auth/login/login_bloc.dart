import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/core/services/sharedpreference_service.dart';

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
    try {
      print("............................runs here");
      final Object response =
          await authService.login(event.email, event.password);

      if (response is LoginResponse) {
        if (response.success) {
          await sharedPreferences.setString('token', response.token!);
          await sharedPreferences.setString('username', response.username!);
          await sharedPreferences.setString('userId', response.userId!);
          print("...........................Saving profile.....");
          if (response.profileData != null) {
            SharedPreferencesService.setProfileData(response.profileData!);
          }

          emit(LoginSuccess(response.token!));
        } else {
          // Handle failed login with a message
          emit(LoginFailure("Login Failed!"));
        }
      } else if (response is LoginResponseModel) {
        // Handle unexpected response type
        emit(LoginFailure(response.message));
      }

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
      emit(LoginFailure(e.toString()));
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
