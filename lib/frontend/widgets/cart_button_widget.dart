import 'package:flutter/material.dart';
// import 'package:shiny_booking/packages.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key, required this.business});

  final BusinessModel business;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, num>?>(
      stream: RepositoryProvider.of<BusinessRepository>(context).getCartTotals(
        business: business.id
      ),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          final data = snapshot.data!;
          final totalItems = data['totalItems'];
          final totalPrice = data['totalPrice'] as double;
          const textStyle = TextStyle(fontSize: 14, height: 1.3, color: Palette.white, fontWeight: FontWeight.bold);

          return SizedBox.fromSize(
            size: const Size(double.infinity, 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                onPressed: () {
                  //  go to checkout
                  context.push(Routes.checkout.path, extra: business);
                },
                elevation: 6,
                color: Primary.darkGreen1,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Row(
                  children: [
                    Expanded(child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/bag-bold.svg',
                          colorFilter: const ColorFilter.mode(Palette.white, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 15.16),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$totalItems Item', style: textStyle),
                              const SizedBox(height: 2),
                              Text(
                                'Booking at ${business.name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, height: 1.3, color: Palette.white),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                    Text('\$${totalPrice.toStringAsFixed(2)}', style: textStyle)
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}