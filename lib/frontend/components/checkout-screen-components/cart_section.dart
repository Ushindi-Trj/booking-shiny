import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';

import 'package:booking_shiny/frontend/components/components.dart';

class CartSection extends StatefulWidget {
  const CartSection({super.key, required this.cart});

  final CartModel cart;

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<CartItemModel> items = widget.cart.items;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final CartItemModel item = items.elementAt(index);

        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction)async => await _removeItem(index, item),
          confirmDismiss: (direction) async => await _removeItemDialog(item.serviceName),
          direction: DismissDirection.endToStart,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${durationToString(item.duration)} - \$${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                )),
                SizedBox.fromSize(
                  size: const Size(58, 28),
                  child: MaterialButton(
                    onPressed: () async {
                      //  Delete item from cart
                      if (await _removeItemDialog(item.serviceName)) {
                        await _removeItem(index, item);
                      }
                    },
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(width: 1, color: Support.red3),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/bin.svg',
                      width: 16, height: 16,
                      colorFilter: const ColorFilter.mode(Support.red3, BlendMode.srcIn),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _removeItemDialog(String serviceName) async {
    return await showDialog(
      context: context,
      builder: (context) => ConfirmDismissDialog(
        title: 'Do you realy want to remove the selected service?',
        subtitle: serviceName,
      )
    );
  }

  Future<void> _removeItem(int index, CartItemModel item) async {
    await RepositoryProvider.of<BusinessRepository>(context).removeServiceFromCart(
      widget.cart.business,
      item
    );
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => const SizedBox.shrink()
    );
    items.removeAt(index);

    if (items.isEmpty) {
      _popAction();
    }
  }

  _popAction() {
    context.pop();
  }
}