import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    this.labelText,
    this.border,
    required this.textEditingController,
    this.validator,
    this.inputType,
    this.hintText,
    this.suffixIcon,
    this.isPassword = false,
    this.focusNode,
    this.maxLength,
    this.onChanged,
    this.textAlign = TextAlign.start,
  });

  final String? labelText;
  final InputBorder? border;
  final TextEditingController textEditingController;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final String? hintText;
  final bool isPassword;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final int? maxLength;
  final Function(String)? onChanged;
  final TextAlign textAlign;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputType,
      controller: widget.textEditingController,
      validator: widget.validator,
      obscureText: _obscureText,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      textAlign: widget.textAlign,
      decoration: InputDecoration(
          counter: null,
          counterText: "",
          labelText: widget.labelText,
          focusedBorder: widget.border ?? InputBorder.none,
          enabledBorder: widget.border ?? InputBorder.none,
          border: widget.border ?? InputBorder.none,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon ??
              ((widget.isPassword)
                  ? IconButton(
                      onPressed: () {
                        if (widget.isPassword) {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        }
                      },
                      icon: Icon((_obscureText)
                          ? Icons.visibility_off
                          : Icons.visibility),
                    )
                  : null)),
    );
  }
}
