import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/core/profile/profile_event.dart';
import 'package:swapifymobile/core/profile/profile_state.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_state.dart';
import 'package:swapifymobile/core/services/profile_service.dart';
import 'package:swapifymobile/core/usecases/user_profile.dart';

import '../services/auth_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;

  ProfileBloc(this.profileService) : super(CreateProfileInitial()) {
    on<CreateUserProfile>((event, emit) async {
      emit(CreateProfileLoading());
      try {
        ResponseModel res =
            await profileService.createProfile(event.userProfile);
        emit(CreateProfileSuccess(res.message));
        // emit(CreateProfileSuccess("Profile Created!"));
      } catch (e) {
        emit(CreateProfileError(e.toString()));
      }
    });
  }
}
