import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    this.buttonText,
    this.buttonWidget,
    required this.onPressed,
  }) : assert((buttonText != null || buttonWidget != null));

  final String? buttonText;
  final Widget? buttonWidget;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: (buttonText != null) ? Text(buttonText!) : buttonWidget);
  }
}
