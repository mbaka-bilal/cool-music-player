
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
