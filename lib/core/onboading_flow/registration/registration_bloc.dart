import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapifymobile/auth/models/response_model.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_event.dart';
import 'package:swapifymobile/core/onboading_flow/registration/registration_state.dart';

import '../../../auth/services/auth_service.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthService authService;
  RegistrationBloc(this.authService) : super(RegistrationInitial()) {
    on<RegisterUser>((event, emit) async {
      emit(RegistrationLoading());
      try {
        ResponseModel res = await authService.register(
            event.email,
            event.password,
            event.name,
            event.phoneNumber,
            event.fullName,
            event.profilePicUrls,
            event.bio);
        emit(RegistrationSuccess(res.message));
        // emit(RegistrationSuccess("Successfully registered!"));
      } catch (e) {
        emit(RegistrationError(e.toString()));
      }
    });

    on<CheckEmailAvailability>((event, emit) async {
      emit(RegistrationLoading());
      try {
        bool isAvailable = await authService.checkEmail(event.email);
        if (isAvailable) {
          emit(EmailAvailable());
        } else {
          emit(EmailInUse());
        }
      } catch (e) {
        emit(RegistrationError(e.toString()));
      }
    });

    on<ResendVerificationEmail>((event, emit) async {
      emit(RegistrationLoading());
      emit(ResendingVerificationEmail());
      try {
        ResponseModel res =
            await authService.resendVerificationEmail(event.email);
        if (res.success) {
          // bool mailsent = true;
          // if (mailsent) {
          emit(VerificationEmailSent());
        } else {
          emit(RegistrationError(res.message));
        }
      } catch (e) {
        emit(RegistrationError(e.toString()));
      }
    });

    on<CompleteVerification>((event, emit) async {
      emit(VerificationLoading());
      try {
        ResponseModel res =
            await authService.completeVerification(event.email, event.code);
        if (res.success) {
          // bool complete = true;
          // if (complete) {
          emit(VerificationComplete());
        } else {
          emit(RegistrationError(res.message));
        }
      } catch (e) {
        emit(RegistrationError(e.toString()));
      }
    });

    on<ResetRegistration>((event, emit) {
      emit(RegistrationInitial());
    });
  }
}
