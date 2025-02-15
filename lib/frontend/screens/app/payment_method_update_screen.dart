import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_unfocuser/flutter_unfocuser.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/backend/cubit/cubits.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class PaymentMethodUpdateScreen extends StatefulWidget {
  const PaymentMethodUpdateScreen({super.key, required this.paymentMethod});

  final PaymentMethodModel paymentMethod;

  @override
  State<PaymentMethodUpdateScreen> createState() => _PaymentMethodUpdateScreenState();
}

class _PaymentMethodUpdateScreenState extends State<PaymentMethodUpdateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _holderName;
  late String _expiryMonth;
  late String _expiryYear;

  void _submitUpdateForm() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    try {
      if (_holderName.isNotEmpty && _expiryMonth.isNotEmpty && _expiryYear.isNotEmpty) {
        context.read<UserCubit>().updateCardRequest(
          paymentMethodId: widget.paymentMethod.id,
          holderName: _holderName,
          expiryMonth: _expiryMonth,
          expiryYear: _expiryYear
        );
      }
    } catch (error) {
      SnackBarWidget.showSnackbarError(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final payment = widget.paymentMethod;

    return BlocListener<UserCubit, UserState>(
      listenWhen: (prev, state) {
        return
          state is UpdateCardLoading ||
          state is UpdateCardDone ||
          state is UpdateCardError
        ;
      },
      listener: (context, state) {
        if (state is UpdateCardLoading) {
          context.loaderOverlay.show();
        } else if (state is UpdateCardDone) {
          _formKey.currentState!.reset();
          context.loaderOverlay.hide();
          context.pop();
        } else if (state is UpdateCardError) {
          context.loaderOverlay.hide();
          SnackBarWidget.showSnackbarError(context: context, message: state.message);
        }
      },
      child: LoadingOverlayWidget(
        child: Unfocuser(
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 64,
              centerTitle: true,
              leading: const PopButtonWidget(),
              title: Text(
                'Update Payment Method',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputTextWidget(
                            initialValue: payment.holderName,
                            label: 'Holder Name',
                            placeholder: 'Enter the card holder name',
                            prefixIcon: 'user.svg',
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            validator: Validation.validateTextField,
                            onSaved: (value) {
                              _holderName = value!;
                            },
                          ),
                          const SizedBox(height: 16),
                          FractionallySizedBox(
                            widthFactor: 0.35,
                            child: InputTextWidget(
                              fieldType: FieldTypes.expiryDate,
                              initialValue: '${payment.expiryMonth}/${payment.expiryYear}',
                              label: 'Expiry Date',
                              placeholder: '08/27',
                              prefixIcon: 'home/booking.svg',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: Validation.validateExpiryDate,
                              onSaved: (value) {
                                if (value!.isNotEmpty && value.length == 5) {
                                  _expiryMonth = value.substring(0, 2);
                                  _expiryYear = value.substring(3, 5);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                    child: Column(children: [
                      _RowText(
                        title: 'Holder Name',
                        text: payment.holderName
                      ),
                      _RowText(
                        title: 'Card Number',
                        text: '.... .... .... ${payment.last4digits}'
                      ),
                      _RowText(
                        title: 'Expiry Date',
                        text: '${payment.expiryMonth}/${payment.expiryYear}'),
                      _RowText(
                        title: 'Brand',
                        text: toBeginningOfSentenceCase(payment.cardBrand)!
                      ),
                      _RowText(
                        title: 'Funding Type',
                        text: toBeginningOfSentenceCase(payment.fundingType)!
                      )
                    ]),
                  )
                ],
              )
            ),
      
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButtonWidget(
                text: 'Update Card',
                onClicked: _submitUpdateForm
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  const _RowText({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium,
          )
        ],
      ),
    );
  }
}
