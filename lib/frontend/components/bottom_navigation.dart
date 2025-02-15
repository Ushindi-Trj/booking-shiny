import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/utils/router/routes.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key, required this.screenBody, required this.location});

  final Widget screenBody;
  final String location;

  @override
  Widget build(BuildContext context) {
    final List<RoutesModel> routes = [Routes.discover, Routes.booking, Routes.favorite, Routes.profile];

    return Scaffold(
      body: screenBody,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Ink(
          height: 100,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(top: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.primaryContainer
            ))
          ),
          child: Row(
            children: routes.map((route) => _NavigationButton(route: route, location: location)).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({required this.route, required this.location});

  final RoutesModel route;
  final String location;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = route.path == location;
    final String selectedIcon = 'assets/icons/home/${route.name}-selected.svg';
    final String unselectedIcon = 'assets/icons/home/${route.name}.svg';

    return Expanded(
      child: SizedBox.fromSize(
        size: const Size(double.infinity, double.infinity),
        child: InkWell(
          onTap: () {
            if (!isSelected) {
              context.go(route.path);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                width: 28, height: 28,
                isSelected ? selectedIcon : unselectedIcon
              ),
              const SizedBox(height: 4),
              Text(
                toBeginningOfSentenceCase(route.name)!,
                style: TextStyle(
                  height: 1.6,
                  letterSpacing: -0.02,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Primary.darkGreen1 : Secondary.grey1
                ),
              )
            ]
          ),
        ),
      )
    );
  }
}