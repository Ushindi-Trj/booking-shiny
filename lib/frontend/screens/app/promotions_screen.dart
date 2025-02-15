import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key, required this.cart});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        centerTitle: true,
        leading: const PopButtonWidget(),
        title: Text(
          'Offers & Promo Codes',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _SearchField(
                onSubmitted: (String? value) {
                  print(value);
                }
              ),
            ),
            Container(
              height: 8,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 24, bottom: 32),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),

            FutureBuilder(
              future: RepositoryProvider.of<BookingRepository>(context).getPromotions(
                cart.items.map((e) => e.serviceId).toList()
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProgressWidget();
                }
                
                final List<PromotionModel> promotions = snapshot.data!;

                if (promotions.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'No promotion found!',
                      style: TextStyle(
                        height: 1.8,
                        fontSize: 18,
                        color: Support.orange1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: promotions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _PromotionItem(
                    promotion: promotions.elementAt(index),
                    cartId: cart.id,
                  )
                );
              }
            )
          ],
        ),
      ),
    );
  }
}

class _PromotionItem extends StatelessWidget {
  const _PromotionItem({required this.promotion, required this.cartId});

  final PromotionModel promotion;
  final String cartId;

  @override
  Widget build(BuildContext context) {
    var validityText = 'Active';

    if (promotion.isActive) {
      validityText = 'Active';
    } else if (promotion.start.isAfter(DateTime.now())) {
      validityText = 'Start on ${DateFormat('EEEE dd MMMM yyyy').format(promotion.start)}';
    } else if (promotion.end.isBefore(DateTime.now())) {
      validityText = 'Expired ${timeago.format(promotion.end)}';
    }

    return StreamBuilder(
      stream: RepositoryProvider.of<BookingRepository>(context).isPromotionSelected(
        cartId: cartId,
        promotionId: promotion.id
      ),
      builder: (context, snapshot) {
        final bool isSelected = snapshot.data ?? false;

        final Color? textColor = isSelected 
          ? Primary.darkGreen3.withOpacity(0.8) 
          : Theme.of(context).textTheme.labelMedium!.color;
        final Color borderColor = isSelected 
          ? Primary.darkGreen3.withOpacity(0.4) 
          : Theme.of(context).colorScheme.primaryContainer;

        return Card(
          elevation: 0,
          color: isSelected ? Primary.darkGreen1.withOpacity(0.1) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(width: 1, color: borderColor)
          ),
          child: InkWell(
            onTap: () {
              RepositoryProvider.of<BookingRepository>(context).selectPromotion(
                cartId: cartId,
                serviceId: promotion.serviceId,
                promotionId: isSelected ? null : promotion.id
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/discount-shape-light.svg',
                        colorFilter: ColorFilter.mode(textColor!, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            promotion.description,
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: textColor
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            validityText,
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: borderColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    promotion.serviceName,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 12,
                      color: textColor
                    ),
                  ),
                ),
              ]
            ),
          ),
        );
      }
    );
  }
}


class _SearchField extends StatefulWidget {
  const _SearchField({required this.onSubmitted});

  final Function(String?) onSubmitted;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: TextFormField(
          focusNode: _focusNode,
          controller: _editingController,
          onFieldSubmitted: widget.onSubmitted,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            height: 1.6,
            fontWeight: FontWeight.w500
          ),
          decoration: InputDecoration(
            hintText: 'Enter the promotion code',
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            hintStyle: const TextStyle(color: Secondary.grey2, height: 1.6, fontSize: 14),
            border: _inputBorder(context),
            enabledBorder: _inputBorder(context),
            focusedBorder: _inputBorder(context),
            suffixIcon: TextButton(
              onPressed: () {
                widget.onSubmitted(_editingController.text);
                _focusNode.unfocus();
              },
              child: const Text(
                'Apply',
                style: TextStyle(
                  height: 1.4,
                  fontSize: 14,
                  color: Primary.darkGreen1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder(BuildContext context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primaryContainer)
  );
}