import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinInput extends StatelessWidget {
  final TextEditingController? controller;
  final int length;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final FormFieldValidator<String>? validator;

  const PinInput({
    super.key,
    this.controller,
    this.length = 6,
    this.obscureText = false,
    this.onChanged,
    this.onCompleted,
    this.validator,
  });

  static const Color _focusedBorderColor = Color.fromRGBO(64, 34, 197, 1);
  static const Color _borderColor = Color.fromRGBO(98, 72, 190, 0.4);

  PinTheme _defaultTheme() {
    return PinTheme(
      width: 40,
      height: 75,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _borderColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = _defaultTheme();

    return Pinput(
      controller: controller,
      length: length,
      obscureText: obscureText,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 13),
      onCompleted: onCompleted,
      onChanged: onChanged,
      validator: validator,
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 1,
            color: _focusedBorderColor,
          ),
        ],
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _focusedBorderColor),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: const Color.fromARGB(50, 76, 175, 80),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 2),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );
  }
}
