import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';


class MyAlert{
  static void showToast({
    required BuildContext context, 
    required String message, 
    Duration duration = const Duration(milliseconds: 2000)
  }) async {
    await Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(top: 8, right: 18, left: 18.0),
      borderRadius: BorderRadius.circular(5),
      backgroundColor: const Color.fromARGB(249, 40, 44, 46),
      duration: duration,
      message: message,
    ).show(context);
  }
}