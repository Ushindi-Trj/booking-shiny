import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:booking_shiny/utils/utils.dart';

import 'package:booking_shiny/data/models/models.dart';

import 'payment_methods_modal.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class PaymentMethodSection extends StatefulWidget {
  const PaymentMethodSection({super.key, required this.cards, required this.onSelected});

  final List<PaymentMethodModel> cards;
  final Function(String) onSelected;

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  late int selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {

    if (widget.cards.isEmpty) {
      return ListTileWidget(
        title: 'Add Payment Method',
        leading: 'bank-light.svg',
        trailing: 'arrow-right.svg',
        onClicked: () {
          context.push(Routes.addPaymentMethod.path);
        },
      );
    } else {
      final selectedCard = widget.cards.elementAt(selectedCardIndex);
      widget.onSelected(selectedCard.id);

      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
            ),
            TextButton(
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => PaymentMethodsModal(
                    cards: widget.cards,
                    selectedCardIndex: selectedCardIndex,
                    onSelected: (index) => setState(() {
                      selectedCardIndex = index;
                    }),
                  )
                );
              },
              style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap
              ),
              child: Text(
                'See All',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          ],
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            selectedCard.holderName,
            style: Theme.of(context).textTheme.labelMedium
          ),
          subtitle: RichText(text: TextSpan(
            style: Theme.of(context).textTheme.labelSmall,
            children: [
              if (selectedCard.isDefault)
                TextSpan(
                  text: 'Default - ',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Support.orange1)
                ),
              TextSpan(text: toBeginningOfSentenceCase(selectedCard.cardBrand)),
            ]
          )),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                fit: BoxFit.contain,
                width: 56, height: 41,
                'assets/card-brands/${selectedCard.cardBrand}.svg',
              )
            ],
          ),
        )
      ]);
    }
  }
}