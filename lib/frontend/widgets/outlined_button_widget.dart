import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';

class OutlinedButtonWidget extends StatelessWidget {
  const OutlinedButtonWidget({
    super.key,
    this.icon,
    required this.text,
    required this.onClicked
  });

  final String text;
  final String? icon;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(double.infinity, 56),
      child: OutlinedButton(
        onPressed: onClicked,
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            return const BorderSide(width: 1, color: Primary.darkGreen1);
          })
        ),
        child: Wrap(
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            icon == null ? const SizedBox.shrink() : SizedBox.fromSize(
              size: const Size(24, 24),
              child: SvgPicture.asset('assets/icons/$icon')
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary
              ),
            ),
          ],
        )
      ),
    );
  }
}