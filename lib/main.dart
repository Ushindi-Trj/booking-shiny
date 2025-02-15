import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:booking_shiny/firebase_options.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/backend/bloc/blocs.dart';
import 'package:booking_shiny/backend/cubit/cubits.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';

import 'package:booking_shiny/frontend/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _checkLocationService();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (_) => ThemeModeRepository()),
      RepositoryProvider(create: (_) => AuthRepository()),
      RepositoryProvider(create: (_) => UserRepository()),
      RepositoryProvider(create: (_) => BusinessRepository()),
      RepositoryProvider(create: (_) => BookingRepository())
    ],
    child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeRepository = RepositoryProvider.of<ThemeModeRepository>(context);

    return FutureBuilder<bool>(
      //  Get the current saved Theme mode
      future: themeRepository.getCurrentMode(),
      builder: (context, snapshot)
      {
        if (snapshot.hasData) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => OnboardingCarouselCubit()),
              BlocProvider(create: (_) => DiscoverBottomSheetCubit()),
              BlocProvider(
                create: (context) => ThemeModeCubit(
                  repository: themeRepository,
                  currentTheme: snapshot.data!,
                ),
              ),
              BlocProvider(create: (context) => AuthBloc(
                repository: RepositoryProvider.of<AuthRepository>(context)
              )),
              BlocProvider(create: (context) => UserCubit(
                repository: RepositoryProvider.of<UserRepository>(context)
              )),
              BlocProvider(
                create: (context) => BusinessBloc(
                  repository: RepositoryProvider.of<BusinessRepository>(context)
                )
              )
            ],
    
            //  Check if User is authenticated or not
            child: Builder(builder: (context) {
              return BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, state) => (state is Authenticated || state is Unauthenticated),
                builder: (context, state) {
                  return (state is Authenticated) ? const AppWidget() : const AuthWidget();
                }
              );
            }),
          );
        }
        return const SplashScreen();
      }
    );
  }
}

//  Return the app (authenticated)
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, bool>(
      buildWhen: (prev, state) => prev != state,
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Shiny Booking',
          debugShowCheckedModeBanner: false,
          routerConfig: RouterConf.appRounter,
          theme: ThemeModeConfig.themeModeConfig(isDark: state)
        );
      }
    );
  }
}

//  Return the authentication screens
class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, bool>(
      buildWhen: (prev, state) => prev != state,
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Shiny Booking',
          debugShowCheckedModeBanner: false,
          routerConfig: RouterConf.authRouter,
          theme: ThemeModeConfig.themeModeConfig(isDark: state),
        );
      }
    );
  }
}

Future<void> _checkLocationService() async {
  if (await Geolocator.isLocationServiceEnabled()) {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
  } else {
    await Geolocator.openLocationSettings();
  }
}