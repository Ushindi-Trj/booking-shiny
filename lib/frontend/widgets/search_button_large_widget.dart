import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/backend/cubit/cubits.dart' show ThemeModeCubit;

class SearchButtonLargeWidget extends StatelessWidget {
  const SearchButtonLargeWidget({super.key, this.bgColor});

  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, bool>(
      builder: (context, isDark) {
        final textColor = isDark ? Secondary.grey1 : Secondary.grey2;

        return InkWell(
          onTap: () {
            //  Show search screen
          },
          borderRadius: BorderRadius.circular(26),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              height: 52,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(width: 1, color: Theme.of(context).colorScheme.primaryContainer)
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/search.svg',
                      colorFilter: ColorFilter.mode(Secondary.grey1, BlendMode.srcIn),
                    ),
                    Text(
                      'What are you looking for',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: textColor
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}