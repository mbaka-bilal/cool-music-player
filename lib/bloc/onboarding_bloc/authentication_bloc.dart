import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/authentication_repository.dart';

import '../../utils/common.dart';
import 'authentication_state.dart';
import 'authentication_event.dart';

class AuthenticationBloc extends Bloc<OnboardingEvent, AuthenticationState> {
  AuthenticationBloc({required this.onboardingRepository})
      : super(const AuthenticationState()) {
    on<RequestOtp>(_mapRequestOtpEventToState);
    on<VerifyOtp>(_mapVerifyOtpEventToState);
    on<ResendOtp>(_mapResendOtpEventToState);
  }

  final AuthenticationRepository onboardingRepository;

  void _mapRequestOtpEventToState(
      RequestOtp event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(signInWithPhoneNumberStatus: RequestStatus.loading));
    final response =
        await onboardingRepository.signInWithPhoneNumber(event.phoneNumber);

    if (response.status != RequestStatus.success) {
      final data = response.data;
      emit(state.copyWith(
          signInWithPhoneNumberStatus: response.status, errorText: data));
    } else {
      //success
      final data = response.data as List<dynamic>;
      emit(state.copyWith(
          signInWithPhoneNumberStatus: response.status,
          verificationId: data[0],
          resendToken: data[1]));
    }
  }

  void _mapVerifyOtpEventToState(
      VerifyOtp event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(
        verifySignInWithPhoneNumberStatus: RequestStatus.loading));

    final response = await onboardingRepository.verifyOtp(
        verificationId: event.verificationId, smsCode: event.code);

    if (response.status != RequestStatus.success) {
      emit(state.copyWith(
          verifySignInWithPhoneNumberStatus: response.status,
          errorText: response.data));
    } else {
      emit(state.copyWith(
          verifySignInWithPhoneNumberStatus: response.status,
          userCredential: response.data));
    }
  }

  void _mapResendOtpEventToState(
      ResendOtp event, Emitter<AuthenticationState> emit) async {
    await onboardingRepository.signInWithPhoneNumber(event.phoneNumber,
        resendToken: event.resendToken);
  }
}
