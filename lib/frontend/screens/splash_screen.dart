import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:booking_shiny/utils/utils.dart';


import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String leafImage = 'https://firebasestorage.googleapis.com/v0/b/shiny-booking.appspot.com/o/divers%2Fleaf.png?alt=media&token=97a00520-fae5-48ac-9dbe-7ed3f2f61780';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Primary.darkGreen1,
        body: Column(
          children: [
            Expanded(child: Align(
              alignment: Alignment.topRight,
              child: CachedNetworkImage(imageUrl: leafImage)
            )),
            Wrap(
              spacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Wrap(
                  spacing: 2.45,
                  children: [
                    Transform.rotate(
                      angle: math.pi,
                      child: const AnimatedIcon()
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15.5),
                      child: const AnimatedIcon()),
                  ],
                ),
                SvgPicture.asset('assets/icons/shiny.svg')
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Stay beauty Everyday',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Palette.white),
            ),
            Expanded(child: Align(
              alignment: Alignment.bottomLeft,
              child: Transform.rotate(
                angle: math.pi,
                child: CachedNetworkImage(imageUrl: leafImage)
              )
            )),
          ]
        ),
      ),
    );
  }
}

class AnimatedIcon extends StatefulWidget {
  const AnimatedIcon({super.key,});

  @override
  State<AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<AnimatedIcon> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360)
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.0,
      end: math.pi
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease)
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            transform: GradientRotation(_animation.value),
            begin: const FractionalOffset(0.5, -0.1),
            end: const FractionalOffset(0.5, 1.0),
            colors: const [
              Primary.darkGreen1,
              Palette.white1
            ]
          ).createShader(rect),
          child: child,
        );
      },
      child: SvgPicture.asset(
        'assets/icons/logo-slice.svg',
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}