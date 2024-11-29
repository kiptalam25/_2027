import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final LoginResponseModel response =
          await authService.login(event.email, event.password);
      if (response.success) {
        await sharedPreferences.setString('token', response.token!);
        await sharedPreferences.setString('username', response.username!);
        await sharedPreferences.setString('userId', response.userId!);
        emit(LoginSuccess(response.token!));
      } else {
        emit(LoginFailure(response.message));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  void _onCheckToken(CheckToken event, Emitter<LoginState> emit) async {
    final token = sharedPreferences.getString('token');
    if (token != null) {
      emit(LoginSuccess(token));
    } else {
      emit(LoginInitial());
    }
  }
}
