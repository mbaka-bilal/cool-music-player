import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/common.dart';
import '../../utils/constants.dart';

class AuthenticationRepository {
  Future<NetworkResponse> signInWithPhoneNumber(String phoneNumber) async {
    ///Request Otp
    return await networkRequestTryCatch(() async {
      final completer = Completer<NetworkResponse>();
      NetworkResponse networkResponse = const NetworkResponse(
        status: RequestStatus.initial,
      );

      // print("attempting to phone number");
      //
      // await Future.delayed(Duration(seconds: 3),() => completer.complete(NetworkResponse(status: RequestStatus.failed,data: "Error")));
      //
      // return completer.future;

      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber: phoneNumber,
        // timeout: const Duration(seconds: 1),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          //Auto verify sms on android;
        },
        verificationFailed: (FirebaseAuthException exception) {
          debugPrint("Error verifying phone number $exception");

          networkResponse = NetworkResponse(
              status: RequestStatus.failed, data: exception.message);
          completer.complete(networkResponse);
        },
        codeSent: (String verificationId, int? resendToken) {
          networkResponse = NetworkResponse(
              status: RequestStatus.success,
              data: [verificationId, resendToken]);

          completer.complete(networkResponse);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          //code retrieval timeout, when attempting to auto verify on android
          // debugPrint("Error codeAutoRetrievalTimeout $verificationId");
          // networkResponse = NetworkResponse(
          //     status: RequestStatus.failed, data: verificationId);
          // completer.complete(networkResponse);
        },
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        networkResponse = const NetworkResponse(
            status: RequestStatus.failed,
            data: Constants.noInternetErrorMessage);
        completer.complete(networkResponse);
      });
      return completer.future;
    }) as NetworkResponse;
  }

  Future<NetworkResponse> verifyOtp(
      {required String verificationId, required String smsCode}) async {
    ///verify otp and grant user access
    return await networkRequestTryCatch(() async {
      print("attempting to verify otp");
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      final UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // print("user is $user and id is ${user.user?.uid}");
      if (user.user != null) {
        return NetworkResponse(status: RequestStatus.success, data: user);
      } else {
        return const NetworkResponse(
            status: RequestStatus.failed, data: Constants.unknownErrorMessage);
      }
    }) as NetworkResponse;
  }
}
