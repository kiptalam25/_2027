import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/core/onboading_flow/profile/profile_event.dart';
import 'package:swapifymobile/core/onboading_flow/profile/profile_state.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_state.dart';

import '../../../auth/services/auth_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthService authService;

  ProfileBloc(this.authService) : super(CreateProfileInitial()) {
    on<CreateProfile>((event, emit) async {
      emit(CreateProfileLoading());
      try {
        // ResponseModel res = await authService.register(event.email,
        //     event.password, event.name, event.phoneNumber, event.bio);
        // emit(RegistrationSuccess(res.message));
        emit(CreateProfileSuccess("Profile Created!"));
      } catch (e) {
        emit(CreateProfileError(e.toString()));
      }
    });
  }
}
