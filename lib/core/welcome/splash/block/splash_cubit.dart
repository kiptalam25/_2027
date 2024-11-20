import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/core/welcome/splash/block/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());
  Future<void> appStarted() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences? sharedPreferences;

    if (_loadToken() != null) {
      emit(Authenticated());
    }
    //else if (_loadEmail() != null) {
    //   emit(IncompleteRegistration());
    // } else {
    emit(UnAuthenticated());
    // }
  }

  Future<String?> _loadEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    return email;
  }

  Future<String?> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return token;
  }
}
