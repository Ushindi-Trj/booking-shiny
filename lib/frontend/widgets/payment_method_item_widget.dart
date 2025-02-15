import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:booking_shiny/backend/cubit/cubits.dart';
import 'package:booking_shiny/data/models/models.dart' show PaymentMethodModel;

import 'package:booking_shiny/frontend/components/components.dart';

class PaymentMthodItem extends StatelessWidget {
  const PaymentMthodItem({super.key, required this.card, required this.onDismissed});

  final PaymentMethodModel card;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (_, current) {
        return
          current is DeleteCardLoading || 
          current is DeleteCardDone || 
          current is DeleteCardError
        ;
      },
      listener: (context, state) {
        if (state is DeleteCardLoading) {
          context.loaderOverlay.show();
        } else if (state is DeleteCardDone) {
          context.loaderOverlay.hide();

          if (card.isDefault) {
            context.read<UserCubit>().fecthCardsRequest();
          }
        } else if (state is DeleteCardError) {
          context.loaderOverlay.hide();
          SnackBarWidget.showSnackbarError(context: context, message: state.message);
        }
      },
      child: Dismissible(
        key: ValueKey<String>(card.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          onDismissed;
          context.read<UserCubit>().deleteCardRequest(card.id);
        },
        confirmDismiss: (direction) async {
          return showDialog(
            context: context,
            builder: (_) => ConfirmDismissDialog(
              title: 'Do you realy want to delete this card?',
              subtitle: card.holderName
            )
          );
        },
        child: ListTile(
          onTap: () {
            //  Go to edit the payment method
            GoRouter.of(context).push(Routes.updatePaymentMethod.path, extra: card);
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            card.holderName,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          subtitle: RichText(text: TextSpan(
            style: Theme.of(context).textTheme.labelSmall,
            children: [
              if (card.isDefault)
                TextSpan(
                  text: 'Default - ',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Support.orange1)
                ),
              TextSpan(text: card.cardBrand),
            ]
          )),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                fit: BoxFit.contain,
                width: 56, height: 41,
                'assets/card-brands/${card.cardBrand}.svg',
              )
            ]
          ),
          trailing: SvgPicture.asset(
            width: 18, height: 18,
            'assets/icons/arrow-right.svg',
            colorFilter: const ColorFilter.mode(Secondary.grey1, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

