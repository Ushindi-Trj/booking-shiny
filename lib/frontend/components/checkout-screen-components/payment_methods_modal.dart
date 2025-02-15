import 'package:flutter/material.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';

import 'package:booking_shiny/data/models/models.dart';

class PaymentMethodsModal extends StatefulWidget {
  const PaymentMethodsModal({
    super.key,
    required this.cards,
    required this.onSelected,
    required this.selectedCardIndex
  });

  final List<PaymentMethodModel> cards;
  final Function(int) onSelected;
  final int selectedCardIndex;

  @override
  State<PaymentMethodsModal> createState() => _PaymentMethodsModalState();
}

class _PaymentMethodsModalState extends State<PaymentMethodsModal> {
  late int indexSelectedCard = widget.selectedCardIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Theme.of(context).colorScheme.secondaryContainer
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Payment Method',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
            ),
          ),

          ListView.separated(
            itemCount: widget.cards.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.83,
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
                ),
              ),
            ),
            itemBuilder: (context, index) {
              final card = widget.cards.elementAt(index);

              return GestureDetector(
                onTap: () {
                  widget.onSelected(index);
                  setState(() {
                    indexSelectedCard = index;
                  });
                },
                child: _CardItem(
                  cardInfo: card,
                  isSelected: indexSelectedCard == index,
                ),
              );
            },
          ),

          ListTileWidget(
            title: 'Add Banking Account',
            leading: 'bank-light.svg',
            trailing: 'arrow-right.svg',
            onClicked: () {
              Navigator.of(context).pop();
              context.push(Routes.addPaymentMethod.path);
            },
          ),
          const SizedBox(height: 32),
          ElevatedButtonWidget(
            text: 'Confirm',
            onClicked: () {
              Navigator.pop(context);
            }
          )
        ]
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem({required this.cardInfo, required this.isSelected});

  final PaymentMethodModel cardInfo;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        cardInfo.holderName,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      subtitle: RichText(text: TextSpan(
        style: Theme.of(context).textTheme.labelSmall,
        children: [
          if (cardInfo.isDefault)
            TextSpan(
              text: 'Default - ',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Support.orange1)
            ),
          TextSpan(text: toBeginningOfSentenceCase(cardInfo.cardBrand)),
        ]
      )),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            fit: BoxFit.contain,
            width: 56, height: 41,
            'assets/card-brands/${cardInfo.cardBrand}.svg',
          )
        ],
      ),
      trailing: isSelected
        ? Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(width: 3, color: Primary.darkGreen1)
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Primary.darkGreen1),
            ),
          )
        : Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(width: 3, color: Theme.of(context).colorScheme.onSurface)
            ),
          )
    );
  }
}
