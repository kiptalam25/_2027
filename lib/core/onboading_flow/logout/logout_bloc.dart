// logout_bloc.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final SharedPreferences sharedPreferences;
  LogoutBloc(this.sharedPreferences) : super(LogoutInitial());

  @override
  Stream<LogoutState> mapEventToState(LogoutEvent event) async* {
    if (event is PerformLogout) {
      yield LogoutInProgress(); // Indicate logout is in progress
      try {
        // Perform logout actions, e.g., clearing tokens or session data
        await Future.delayed(Duration(seconds: 1));
        sharedPreferences.clear();
        yield LogoutSuccess(); // Logout was successful
      } catch (e) {
        yield LogoutFailure(
            e.toString()); // Handle failure and emit an error state
      }
    }
  }
}
