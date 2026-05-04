import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:iventi/shared/theme/AppColors.dart';

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

  static const Color _focusedBorderColor = AppColors.primary;
  static const Color _borderColor = AppColors.border;

  PinTheme _defaultTheme() {
    return PinTheme(
      width: 40,
      height: 75,
      textStyle: const TextStyle(
        fontSize: 22,
        color: AppColors.textDark,
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
      autofocus: false,
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
          color: AppColors.success.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.success, width: 2),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: AppColors.danger),
      ),
    );
  }
}
