import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'constants.dart';

enum RequestStatus { loading, initial, success, failed, noNetwork }

class NetworkResponse {
  final RequestStatus status;
  final dynamic data;

  const NetworkResponse({
    required this.status,
    this.data,
  });
}

Future<Object?> networkRequestTryCatch<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on TimeoutException catch (e) {
    debugPrint("Network Timeout $e");
    return const NetworkResponse(
        status: RequestStatus.noNetwork, data: Constants.noInternetErrorMessage);
  } on ClientException catch (e) {
    debugPrint("Client exception $e");
    return const NetworkResponse(
        status: RequestStatus.noNetwork, data: Constants.noInternetErrorMessage);
  } on FirebaseAuthException catch (e) {
    debugPrint("firebase auth exception $e");
    return NetworkResponse(
        status: RequestStatus.failed, data: e.message);
  }catch (e) {
    debugPrint("Unknown error $e");
    return const NetworkResponse(
        status: RequestStatus.failed, data: Constants.unknownErrorMessage);
  }
}
