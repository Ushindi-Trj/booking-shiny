import 'package:flutter/material.dart';

class SnackBarWidget {
  static void showSnackbarError({required context, required message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 620),
        content: Text(message)
      ))
    ;
  }
}