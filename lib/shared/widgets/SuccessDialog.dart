import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends AwesomeDialog {
  SuccessDialog({
    required super.context,
    required String title,
    required String description,
    void Function()? btnOkOnPress,
  }) : super(
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: title,
          desc: description,
          btnOkOnPress: btnOkOnPress ?? () {},
          btnOkIcon: Icons.check_circle,
          btnOkColor: Colors.green,
        ) {
    show();
  }
}
