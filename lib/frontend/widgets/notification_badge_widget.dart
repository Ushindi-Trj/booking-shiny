import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';

class NotificationBadgeWidget extends StatelessWidget {
  const NotificationBadgeWidget({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Badge(
      largeSize: 18,
      label: const Text('9+'),
      backgroundColor: Support.red1,
      textStyle: const TextStyle(fontSize: 13),
      alignment: AlignmentDirectional(size==44 ? 25 : 30, -4),
      child: InkWell(
        onTap: () {
          //  Show notification screen
        },
        borderRadius: BorderRadius.circular(100),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            width: size, height: size,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 1.5, color: Theme.of(context).colorScheme.primaryContainer)
            ),
            child: Padding(
              padding: EdgeInsets.all(size==44 ? 10 : 12),
              child: SvgPicture.asset(
                'assets/icons/notification.svg',
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}