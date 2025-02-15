import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:booking_shiny/backend/cubit/cubits.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';


class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<_OnboardingModel> _contents = const [
    _OnboardingModel(
      title: 'Browse a wide range of beauty services and treatments',
      description: 'Shiny makes it easy to explore and book a variety of beauty services and treatments from top-rated providers near you.',
      image: {
        'dark': 'https://firebasestorage.googleapis.com/v0/b/shiny-booking.appspot.com/o/divers%2Fonboarding-1-dark.png?alt=media&token=f08d3fad-dc08-4633-9403-9fe5a3d5ffcf',
        'light': 'https://firebasestorage.googleapis.com/v0/b/shiny-booking.appspot.com/o/divers%2Fonboarding-1-light.png?alt=media&token=c8af92e2-f0f5-4917-a7a5-1f8115798192'
      }
    ),
    _OnboardingModel(
      title: 'Book appointments at your convenience',
      description: 'Schedule and manage your beauty appointments at any time, from anywhere. Say goodbye to waiting on hold or trying to coordinate with your busy schedule.',
      image: {
        'dark': 'https://firebasestorage.googleapis.com/v0/b/shiny-booking.appspot.com/o/divers%2Fonboarding-2-dark.png?alt=media&token=d98cac7b-7489-413a-aba6-39ca27358d0f',
        'light': 'https://firebasestorage.googleapis.com/v0/b/shiny-booking.appspot.com/o/divers%2Fonboarding-2-light.png?alt=media&token=f0a2039e-fe24-452a-976c-15540cde5848'
      }
    ),
    _OnboardingModel(
      title: 'Track your appointment history information',
      description: 'Stay organized and never miss a beat. With Shiny, you can access all of your appointment history including dates, times, and service providers.',
      image: {
        'dark': 'https://firebasestorage.googleapis.com/v0/b/shiny-booking.appspot.com/o/divers%2Fonboarding-3-dark.png?alt=media&token=d7a4d3e1-ad37-4959-8e56-066e0b1b16d5',
        'light': 'https://firebasestorage.googleapis.com/v0/b/shiny-booking.appspot.com/o/divers%2Fonboarding-3-light.png?alt=media&token=854961b9-0b5d-4ee6-9491-7a3f5d8499e6'
      }
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.8;

    return BlocBuilder<ThemeModeCubit, bool>( // Get the current theme mode
      buildWhen: (_, __) => false,
      builder: (context, themeIsDark) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: AppBar().preferredSize.height),
              child: BlocBuilder<OnboardingCarouselCubit, int>(
                buildWhen: (prev, state) => prev != state,
                builder: (_, state) {
                  final content = _contents.elementAt(state);

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    transitionBuilder: ((child, animation) => FadeTransition(
                      opacity: animation,
                      child: child
                    )),
                    child: CachedNetworkImage(
                      key: ValueKey<int>(state),
                      width: screenWidth,
                      fit: BoxFit.contain,
                      imageUrl: themeIsDark ? content.image['dark']! : content.image['light']!,
                    )
                  );
                }
              )),
          ),

          bottomSheet: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [BoxShadow(
                blurRadius: 40,
                spreadRadius: 1.2,
                offset: const Offset(0, -5),
                color: Theme.of(context).colorScheme.secondary
              )]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xffD8DBE5),
                    borderRadius: BorderRadius.circular(40)
                  )
                ),
                const SizedBox(height: 24),

                FlutterCarousel.builder(
                  itemCount: _contents.length,
                  itemBuilder: (context, index, pageViewIndex) {
                    final content = _contents.elementAt(index);

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          content.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          content.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ]
                    );
                  },
                  options: FlutterCarouselOptions(
                    autoPlay: false,
                    initialPage: 0,
                    aspectRatio: 2.4,
                    pageSnapping: true,
                    viewportFraction: 1.0,
                    showIndicator: false,
                    onPageChanged: (index, reason) {
                      context.read<OnboardingCarouselCubit>().onCarouselChanged(index);
                    },
                  ),
                ),
                
                BlocBuilder<OnboardingCarouselCubit, int>(
                  buildWhen: (prev, state) => prev != state,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Wrap(
                        spacing: 12,
                        children: List.generate(_contents.length, (index) => Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (state==index) ? Support.orange2 : themeIsDark ? const Color(0xff292C2A) : Secondary.grey3,
                          ),
                        )),
                      ),
                    );
                  }
                ),

                ElevatedButtonWidget(
                  text: 'Continue',
                  onClicked: () => context.pushNamed(Routes.signup.name)
                ),
                const SizedBox(height: 16),
                OutlinedButtonWidget(
                  onClicked: () => context.pushNamed(Routes.login.name),
                  text: 'Login to Your Account',
                )
              ],
            ),
          ),
        );
      }
    );
  }
}


class _OnboardingModel {
  final String title;
  final String description;
  final Map<String, String> image;

  const _OnboardingModel({required this.title, required this.description, required this.image});
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}