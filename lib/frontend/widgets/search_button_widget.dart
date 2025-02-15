import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchButtonWidget extends StatelessWidget {
  const SearchButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //  Show Search screen
      },
      borderRadius: BorderRadius.circular(100),
      child: Ink(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 1.5, color: Theme.of(context).colorScheme.primaryContainer)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}