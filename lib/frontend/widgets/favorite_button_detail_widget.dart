import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:booking_shiny/data/repositories/repositories.dart' show BusinessRepository;

import 'package:booking_shiny/backend/cubit/cubits.dart' show ThemeModeCubit;
import 'package:booking_shiny/backend/bloc/blocs.dart' show BusinessBloc, ToggleFavoriteRequested;

class FavoriteButtonDetailWidget extends StatelessWidget {
  const FavoriteButtonDetailWidget({super.key, required this.isMaxSized, required this.businessId});

  final bool isMaxSized;
  final String businessId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RepositoryProvider.of<BusinessRepository>(context).checkFavorite(businessId),
      builder: (context, snapshot) {
        final isFavorite = snapshot.data ?? false;

        return BlocBuilder<ThemeModeCubit, bool>(
          builder: (context, isDark) {
            var borderColor = Colors.transparent;
            var iconColor = Palette.white;

            if (isDark) {
              borderColor = isMaxSized ? Support.dBlack2 : Colors.transparent;
              iconColor = isFavorite ? Support.orange1 : Palette.white;
            } else {
              borderColor = isMaxSized ? Secondary.lightGrey1 : Colors.transparent;
              iconColor = isFavorite ? Support.orange1 : isMaxSized ? Primary.black1 : Palette.white;
            }

            return SizedBox.square(
              dimension: 44,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Material(
                  color: !isMaxSized ? Primary.black1.withOpacity(0.25) : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(width: 1.5, color: borderColor),
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.read<BusinessBloc>().add(ToggleFavoriteRequested(
                        isFavorite: !isFavorite,
                        businessId: businessId
                      ));
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/heart-${isFavorite ? 'bold' : 'light'}.svg',
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    )
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}