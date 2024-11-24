import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapifymobile/core/welcome/splash/block/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  Future<void> appStarted() async {
    await Future.delayed(const Duration(seconds: 3));

    String? token = await _getToken();

    if (token != null) {
      emit(Authenticated());
    } else {
      // You can uncomment and use this if you want to check the email as a fallback
      // String? email = await _loadEmail();
      // if (email != null) {
      //   emit(IncompleteRegistration());
      // } else {
      emit(UnAuthenticated());
      // }
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _loadEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}
