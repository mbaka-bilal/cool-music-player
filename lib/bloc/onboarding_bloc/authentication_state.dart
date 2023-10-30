import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/common.dart';

class AuthenticationState extends Equatable {
  final RequestStatus requestOtpStatus;
  final RequestStatus verifyOtp;
  final String? verificationId;
  final String? errorText;
  final int? resendToken;
  final UserCredential? userCredential;

  const AuthenticationState({
    this.requestOtpStatus = RequestStatus.initial,
    this.verifyOtp = RequestStatus.initial,
    this.verificationId,
    this.errorText,
    this.resendToken,
    this.userCredential,
  });

  AuthenticationState copyWith({
    RequestStatus? signInWithPhoneNumberStatus,
    RequestStatus? verifySignInWithPhoneNumberStatus,
    String? verificationId,
    String? errorText,
    int? resendToken,
    UserCredential? userCredential,
  }) {
    return AuthenticationState(
      requestOtpStatus:
          signInWithPhoneNumberStatus ?? this.requestOtpStatus,
      verifyOtp: verifySignInWithPhoneNumberStatus ??
          this.verifyOtp,
      verificationId: verificationId ?? this.verificationId,
      errorText: errorText ?? this.errorText,
      resendToken: resendToken ?? this.resendToken,
      userCredential: userCredential ?? this.userCredential,
    );
  }

  @override
  List<Object?> get props =>
      [requestOtpStatus, verificationId, errorText,verifyOtp,resendToken,userCredential,];
}
