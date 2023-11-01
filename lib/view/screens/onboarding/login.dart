import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/onboarding_bloc/authentication_bloc.dart';
import '../../../bloc/onboarding_bloc/authentication_event.dart';
import '../../../bloc/onboarding_bloc/authentication_state.dart';
import '../../../controller/form_validator.dart';
import '../../../utils/common.dart';
import '../../widgets/button.dart';
import '../../widgets/text_form.dart';
import '../otp_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _phoneNumberFormKey = GlobalKey<FormState>();
  final _emailPasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _emailPasswordFormKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                      "Get more feature when you login or create an account"
                      "such as live listening sessions with friends, live chat,"
                      " and sharing of your playlist."),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Enter email"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormFieldWidget(
                    textEditingController: _emailController,
                    hintText: "jhondoe@gmail.com",
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Enter password"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormFieldWidget(
                    textEditingController: _passwordController,
                    isPassword: true,
                    hintText: "*********",
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ButtonWidget(
                      onPressed: () {
                        if (!_emailPasswordFormKey.currentState!.validate()) {
                          return;
                        }
                      },
                      buttonText: "Login",
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "OR USE",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            //Login with gmail
                          },
                          icon: const Icon(
                            Icons.mail,
                            size: 30,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            // _enterOtpBottomSheet();
                            _enterPhoneNumberBottomSheet();
                          },
                          icon: const Icon(
                            Icons.phone,
                            size: 30,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            //login with facebook
                          },
                          icon: const Icon(
                            Icons.facebook,
                            size: 30,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            //login with twitter
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 30,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _enterPhoneNumberBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state.requestOtpStatus == RequestStatus.success) {
                    Navigator.pop(context);
                    _enterOtpBottomSheet();
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _phoneNumberFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormFieldWidget(
                          textEditingController: _phoneNumberController,
                          inputType: TextInputType.phone,
                          validator: FormValidator.validatePhoneNumber,
                          labelText: "Enter your phone number",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state.requestOtpStatus == RequestStatus.failed ||
                            state.requestOtpStatus == RequestStatus.noNetwork)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(state.errorText!),
                          ),
                        (state.requestOtpStatus == RequestStatus.loading)
                            ? const CupertinoActivityIndicator()
                            : ButtonWidget(
                                buttonText: "Continue",
                                onPressed: () {
                                  if (!_phoneNumberFormKey.currentState!
                                      .validate()) {
                                    return;
                                  }

                                  context.read<AuthenticationBloc>().add(RequestOtp(
                                      phoneNumber:
                                          _phoneNumberController.text));
                                })
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  void _enterOtpBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return OtpScreen(
            phoneNumber: _phoneNumberController.text,
          );
        });
  }
}
