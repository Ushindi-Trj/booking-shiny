import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:booking_shiny/frontend/screens/app/app_screens.dart';
import 'package:booking_shiny/frontend/screens/auth/auth_screens.dart';
import 'package:booking_shiny/frontend/components/bottom_navigation.dart';
import 'package:booking_shiny/frontend/screens/not_fount_screen.dart';

import 'routes.dart' hide RoutesModel;
import 'package:booking_shiny/data/models/models.dart';

class RouterConf {
  static final _routeNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter authRouter = GoRouter(
    initialLocation: Routes.onboarding.path,
    routes: [
      GoRoute(
        name: Routes.onboarding.name,
        path: Routes.onboarding.path,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: Routes.login.name,
        path: Routes.login.path,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: Routes.signup.name,
        path: Routes.signup.path,
        builder: (context, state) => const SignupScreen(),
      ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: NotFoundScreen());
    },
  );

  static GoRouter appRounter = GoRouter(
    initialLocation: Routes.discover.path,
    navigatorKey: _routeNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(child: BottomNavigation(
            screenBody: child,
            location: state.uri.toString(),
          ));
        },
        routes: [
          GoRoute(
            name: Routes.discover.name,
            path: Routes.discover.path,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) {
              return const DiscoverScreen();
            },
            routes: [
              GoRoute(
                name: Routes.businessFilter.name,
                path: Routes.businessFilter.path,
                parentNavigatorKey: _routeNavigatorKey,
                builder: (context, state) {
                  return FilterScreen(category: state.pathParameters['category']!);
                }
              ),
              GoRoute(
                name: Routes.popularBusinesses.name,
                path: Routes.popularBusinesses.name,
                parentNavigatorKey: _routeNavigatorKey,
                builder: (context, state) {
                  return const PopularBusinessesScreen();
                }
              ),
              GoRoute(
                name: Routes.history.name,
                path: Routes.history.name,
                parentNavigatorKey: _routeNavigatorKey,
                builder: (context, state) {
                  return const HistoryScreen();
                }
              ),
            ]
          ),
          GoRoute(
            name: Routes.booking.name,
            path: Routes.booking.path,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) {
              return const BookingScreen();
            }
          ),
          GoRoute(
            name: Routes.favorite.name,
            path: Routes.favorite.path,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) {
              return const FavoriteScreen();
            }
          ),
          GoRoute(
            name: Routes.profile.name,
            path: Routes.profile.path,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (context, state) {
              return const ProfileScreen();
            },
            routes: [
              GoRoute(
                name: Routes.profileEdit.name,
                path: Routes.profileEdit.name,
                parentNavigatorKey: _routeNavigatorKey,
                builder: (context, state) {
                  return const EditProfileScreen();
                }
              ),
              GoRoute(
                name: Routes.paymentMethods.name,
                path: Routes.paymentMethods.name,
                parentNavigatorKey: _routeNavigatorKey,
                builder: (context, state) {
                  return const PaymentMethodsScreen();
                }
              ),
            ]
          ),
        ]
      ),

      GoRoute(
        name: Routes.details.name,
        path: Routes.details.path,
        parentNavigatorKey: _routeNavigatorKey,
        builder: (context, state) {
          return BusinessDetailScreen(business: state.extra as BusinessModel);
        }
      ),
      GoRoute(
        name: Routes.checkout.name,
        path: Routes.checkout.path,
        parentNavigatorKey: _routeNavigatorKey,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: CheckoutScreen(business: state.extra! as BusinessModel)
          );
        }
      ),
      GoRoute(
        name: Routes.promotion.name,
        path: Routes.promotion.path,
        parentNavigatorKey: _routeNavigatorKey,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: PromotionsScreen(cart: state.extra! as CartModel)
          );
        }
      ),
      GoRoute(
        name: Routes.addPaymentMethod.name,
        path: Routes.addPaymentMethod.path,
        parentNavigatorKey: _routeNavigatorKey,
        builder: (context, state) {
          return const PaymentMethodAddScreen();
        }
      ),
      GoRoute(
        name: Routes.updatePaymentMethod.name,
        path: Routes.updatePaymentMethod.path,
        parentNavigatorKey: _routeNavigatorKey,
        builder: (context, state) {
          return PaymentMethodUpdateScreen(paymentMethod: state.extra as PaymentMethodModel);
        }
      ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: NotFoundScreen());
    },
  );
}