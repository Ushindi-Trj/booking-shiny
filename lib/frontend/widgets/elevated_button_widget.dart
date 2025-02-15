import 'package:flutter/material.dart';
import 'package:booking_shiny/utils/utils.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.onClicked,
    this.isLoading = false,
  });

  final String text;
  final bool isLoading;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(double.infinity, 56),
      child: ElevatedButton(
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Primary.darkGreen1,
          disabledBackgroundColor: Primary.darkGreen1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
          ),
        ),
        child: isLoading
          ? SizedBox.fromSize(
              size: const Size(26, 26),
              child: const CircularProgressIndicator(color: Palette.white, strokeWidth: 1.5),
            )
          : Text(
            text,
            style: const TextStyle(fontSize: 14, color: Palette.white, fontWeight: FontWeight.bold),
          )
      ),
    );
  }
}