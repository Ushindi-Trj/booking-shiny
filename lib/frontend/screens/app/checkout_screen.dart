import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_shiny/utils/utils.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.business});

  final BusinessModel business;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late DateTime _selectedDateTime = DateTime.now();
  late String _selectedPaymentCardId;
  late String _cartId;

  @override
  Widget build(BuildContext context) {
    final separatorBorderColor = Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8);
    final BusinessModel business = widget.business;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        centerTitle: true,
        leading: const PopButtonWidget(),
        title: Text(
          'Request Appointment',
          style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([
          RepositoryProvider.of<BookingRepository>(context).getCart(business.id),
          RepositoryProvider.of<UserRepository>(context).fetchCards()
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProgressWidget();
          }

          final CartModel cart = snapshot.data![0] as CartModel;
          final List<PaymentMethodModel> paymentMethods = snapshot.data![1] as List<PaymentMethodModel>;

          _cartId = cart.id;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: kFloatingActionButtonMargin + 90
            ),
            child: Column(children: [
              //  Business && cart items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BusinessItemWidget(business: business),
                    Container(
                      height: 1,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 24, bottom: 16),
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                    ),
                    CartSection(cart: cart)
                  ],
                ),
              ),

              Container(
                height: 8,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16, bottom: 6),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),

              //  Date Time and Offers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ListTileWidget(
                      onClicked: () {
                        showModalBottomSheet(
                          context: context,
                          enableDrag: true,
                          useSafeArea: true,
                          isDismissible: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SelectDateTimeModal(
                            openingHours: business.openingHours,
                            selectedDateTime: _selectedDateTime,
                            onSelected: (DateTime date) {
                              _selectedDateTime = date;
                            },
                          )
                        );
                      },
                      title: 'Select Date & Time',
                      subtitle: 'Choose Date and Time to book',
                      leading: 'home/booking.svg',
                      trailing: 'arrow-right.svg',
                    ),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: separatorBorderColor
                    ),
                    ListTileWidget(
                      onClicked: () {
                        context.push(Routes.promotion.path, extra: cart);
                      },
                      title: 'Offers & Promo Code',
                      subtitle: 'Let\'s use it before it\' burnt',
                      leading: 'discount-shape-light.svg',
                      trailing: 'arrow-right.svg',
                    ),
                  ],
                ),
              ),
              
              Container(
                height: 8,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 6, bottom: 16),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),

              //  Payment method
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PaymentMethodSection(
                  cards: paymentMethods,
                  onSelected: (String cardId) {
                    _selectedPaymentCardId = cardId;
                  },
                ),
              ),

              Container(
                height: 8,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24, top: 12),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),

              //  Total prices
              StreamBuilder(
                stream: RepositoryProvider.of<BookingRepository>(context).getStreamCartSubtotal(
                  cart.id
                ),
                builder: (context, snapshot) {
                  double total = 0.00;
                  double discount = 0.00;
                  double subTotal = 0.00;

                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    total = data['total'];
                    discount = data['discount'];
                    subTotal = data['subtotal'];
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        ],
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: separatorBorderColor,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Coupon Discount', style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            '\$${discount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        ],
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: separatorBorderColor,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Amount Payable', style: Theme.of(context).textTheme.labelMedium),
                          Text(
                            '\$${subTotal.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        ],
                      ),
                    ]),
                  );
                }
              )
            ]),
          );
        }
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButtonWidget(
          text: 'Checkout Now',
          onClicked: () => RepositoryProvider.of<BookingRepository>(context).placeBooking(
            cartId: _cartId,
            dateTime: _selectedDateTime,
            paymentCardId: _selectedPaymentCardId
          )
        ),
      ),
    );
  }
}