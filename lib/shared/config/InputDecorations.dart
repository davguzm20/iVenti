import 'package:flutter/material.dart';

class InputDecorations {
  InputDecorations._();

  static InputDecoration standard({
    required String label,
    bool isRequired = false,
    bool isPrice = false,
    String? suffixText,
  }) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: isRequired ? '$label *' : label,
      hintText: isPrice ? '0.00' : null,
      prefixText: isPrice ? 'S/ ' : null,
      suffixText: isPrice ? '' : suffixText,
      suffixStyle: TextStyle(color: Colors.grey.shade600),
    );
  }
}
