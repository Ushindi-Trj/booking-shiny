import 'package:flutter/material.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key, this.padding = 0});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: padding),
        child: const SpinKitWanderingCubes(
          size: 36,
          color: Support.orange1,
        ),
      ),
    );
  }
}