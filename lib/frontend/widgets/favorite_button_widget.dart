import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:booking_shiny/backend/bloc/blocs.dart';
import 'package:booking_shiny/data/repositories/repositories.dart' show BusinessRepository;

import 'package:booking_shiny/utils/utils.dart';

class FavoriteButtonWidget extends StatelessWidget {
  const FavoriteButtonWidget({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: RepositoryProvider.of<BusinessRepository>(context).checkFavorite(businessId),
      builder: (context, snapshot) {
        final bool isFavorite = snapshot.data ?? false;

        return IconButton(
          onPressed: () {
            context.read<BusinessBloc>().add(ToggleFavoriteRequested(
              businessId: businessId,
              isFavorite: !isFavorite
            ));
          },
          icon: SvgPicture.asset(
            'assets/icons/heart-${isFavorite ? 'bold' : 'light'}.svg',
            colorFilter: ColorFilter.mode(isFavorite ? Support.orange1 : Primary.black1, BlendMode.srcIn),
          )
        );
      }
    );
  }
}