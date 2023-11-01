import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/onboarding_bloc/authentication_bloc.dart';
import '../../bloc/onboarding_bloc/authentication_event.dart';
import '../../bloc/onboarding_bloc/authentication_state.dart';
import '../../utils/common.dart';
import '../widgets/button.dart';
import '../widgets/text_form.dart';

class OtpScreen extends StatefulWidget {
  ///Enter otp, verify and grant access.

  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _textControllers =
      List.generate(6, (index) => TextEditingController());
  Timer? _timer;
  int resendCodeCounter = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    resendCodeCounter = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCodeCounter == 0) {
        timer.cancel();
      } else {
        resendCodeCounter--;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    for (FocusNode f in _focusNodes) {
      f.dispose();
    }
    for (TextEditingController c in _textControllers) {
      c.dispose();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter otp sent to the phone number ${widget.phoneNumber}"),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                      6,
                      (index) => Container(
                            width: 40,
                            height: 50,
                            margin: const EdgeInsets.all(10),
                            child: TextFormFieldWidget(
                              textEditingController: _textControllers[index],
                              inputType: TextInputType.number,
                              focusNode: _focusNodes[index],
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              onChanged: (str) {
                                if (str.trim().length == 1) {
                                  _focusNodes[index].nextFocus();
                                } else {
                                  _focusNodes[index].previousFocus();
                                }
                              },
                            ),
                          ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {},
              builder: (context, state) => Column(
                children: [
                  if (state.verifyOtp == RequestStatus.failed ||
                      state.verifyOtp == RequestStatus.noNetwork)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(state.errorText!),
                    ),
                  (state.verifyOtp == RequestStatus.loading)
                      ? const CupertinoActivityIndicator()
                      : ButtonWidget(
                          onPressed: () {
                            final String number = _textControllers
                                .map((controller) => controller.text)
                                .toList()
                                .join();
                            if (number.length < 6) {
                              Fluttertoast.showToast(
                                  msg: "Please fill in all fields");
                            } else {
                              //submit otp

                              // context.read<OnboardingBloc>().add(VerifyOtp(
                              //     code: number,
                              //     verificationId:
                              //         "AD8T5IvV5627TpZuNkGbOYndYF6uqgjjULCicjDNq1a0lbem-fEI1ld4vFcA4v_mbzVX0xh81J1E3lpvjGJfL6QtykMlWSX4z4jzPP9rpDYksPcQn11xFXOmIPCSy81SE49Q0yLSqlYBYz2ua4Sf7WgA5RQgo3onHQ"));

                              if (state.verificationId != null) {
                                context.read<AuthenticationBloc>().add(
                                    VerifyOtp(
                                        code: number,
                                        verificationId: state.verificationId!));
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "Verification Id is empty, please restart the otp process");
                              }
                            }
                          },
                          buttonText: "Continue",
                        ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            (resendCodeCounter == 0)
                ? TextButton(
                    onPressed: () {
                      _startTimer();
                      final provider = context.read<AuthenticationBloc>();
                      provider.add(ResendOtp(
                          phoneNumber: widget.phoneNumber,
                          resendToken: provider.state.resendToken));
                    },
                    child: const Text(
                      "Resend code",
                    ))
                : Text("Request a new code in 00:$resendCodeCounter")
          ],
        ),
      ),
    );
  }
}
