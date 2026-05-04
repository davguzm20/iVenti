import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends AwesomeDialog {
  ErrorDialog({
    required super.context,
    required String title,
    required String description,
    dynamic Function()? btnOkOnPress,
  }) : super(
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: title,
          desc: description,
          btnOkOnPress: btnOkOnPress ?? () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red,
        ) {
    show();
  }
}
