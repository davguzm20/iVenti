import 'package:flutter/material.dart';
import 'package:iventi/shared/theme/AppColors.dart';

class ButtonStyles {
  ButtonStyles._();

  static ButtonStyle primary({double? borderRadius}) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
    );
  }

  static ButtonStyle success({double? borderRadius}) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.success,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
    );
  }

  static ButtonStyle outlinedToggle(bool isSelected) {
    return OutlinedButton.styleFrom(
      backgroundColor: isSelected ? AppColors.primary : Colors.white,
      foregroundColor: isSelected ? Colors.white : AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
    );
  }

  static ButtonStyle text() {
    return TextButton.styleFrom(foregroundColor: AppColors.primary);
  }

  static ButtonStyle dangerText() {
    return TextButton.styleFrom(foregroundColor: AppColors.danger);
  }
}
