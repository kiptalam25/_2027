import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/presentation/splash/block/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());
  Future<void> appStarted() async {
    await Future.delayed(const Duration(seconds: 10));
    emit(UnAuthenticated());
  }
}
