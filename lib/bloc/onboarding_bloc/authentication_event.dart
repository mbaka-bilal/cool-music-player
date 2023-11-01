
class OnboardingEvent {
  const OnboardingEvent();
}

class RequestOtp extends OnboardingEvent {
  const RequestOtp({required this.phoneNumber,this.verificationId});

  final String phoneNumber;
  final String? verificationId;
}

class VerifyOtp extends OnboardingEvent {
  const VerifyOtp({required this.code,required this.verificationId});

  final String code;
  final String verificationId;
}

class ResendOtp extends OnboardingEvent {
  const ResendOtp({required this.phoneNumber,required this.resendToken});

  final int? resendToken;
  final String phoneNumber;
}
