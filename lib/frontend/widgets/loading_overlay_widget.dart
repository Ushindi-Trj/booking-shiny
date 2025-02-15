import 'package:flutter/material.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlayWidget extends StatelessWidget {
  const LoadingOverlayWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      // overlayOpacity: 0.0,
      overlayColor: Color(0x80000000),
      overlayWholeScreen: true,
      disableBackButton: false,
      closeOnBackButton: true,
      overlayWidgetBuilder: (progress) => SpinKitWanderingCubes(
        size: 36,
        color: Support.orange1,
      ),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: child,
    );
  }
}