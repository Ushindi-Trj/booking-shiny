import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_unfocuser/flutter_unfocuser.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/backend/cubit/cubits.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class PaymentMethodAddScreen extends StatefulWidget {
  const PaymentMethodAddScreen({super.key});

  @override
  State<PaymentMethodAddScreen> createState() => _PaymentMethodAddScreenState();
}

class _PaymentMethodAddScreenState extends State<PaymentMethodAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _holderName;
  late String _cardNumber;
  late String _expiryMonth;
  late String _expiryYear;
  late String _cvv;

  void _submitAddForm() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState?.save();
    try {
      if (_holderName.isNotEmpty &&
          _cardNumber.isNotEmpty &&
          _expiryMonth.isNotEmpty &&
          _expiryYear.isNotEmpty &&
          _cvv.isNotEmpty
      ) {
        BlocProvider.of<UserCubit>(context).addNewCardRequest(
          holderName: _holderName,
          cardNumber: _cardNumber,
          expiryMonth: _expiryMonth,
          expiryYear: _expiryYear,
          cvv: _cvv,
        );
      }
    } catch (error) {
      SnackBarWidget.showSnackbarError(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (prev, current) {
        return 
          current is AddCardLoading ||
          current is AddCardDone ||
          current is AddCardError
        ;
      },
      listener: (context, state) {
        if (state is AddCardLoading) {
          context.loaderOverlay.show();
        } else if (state is AddCardError) {
          context.loaderOverlay.hide();
          SnackBarWidget.showSnackbarError(context: context, message: state.message);
        } else if (state is AddCardDone) {
          _formKey.currentState!.reset();
          context.loaderOverlay.hide();
          context.pop();
        }
      },
      child: LoadingOverlayWidget(
        child: Unfocuser(
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 64,
              centerTitle: true,
              leading: const PopButtonWidget(),
              title: Text('Add Payment Method',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputTextWidget(
                        label: 'Holder Name',
                        placeholder: 'Enter the card holder name',
                        prefixIcon: 'user.svg',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: Validation.validateTextField,
                        onSaved: (value) {
                          _holderName = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      InputTextWidget(
                        fieldType: FieldTypes.creditCard,
                        label: 'Card Number',
                        placeholder: '0000 0000 0000 0000',
                        prefixIcon: 'credit-card-light.svg',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: Validation.validateCardNumber,
                        onSaved: (value) {
                          _cardNumber = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InputTextWidget(
                              fieldType: FieldTypes.expiryDate,
                              label: 'Expiry Date',
                              placeholder: '08/27',
                              prefixIcon: 'home/booking.svg',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: Validation.validateExpiryDate,
                              onSaved: (value) {
                                if (value!.isNotEmpty && value.length == 5) {
                                  _expiryMonth = value.substring(0, 2);
                                  _expiryYear = value.substring(3, 5);
                                }
                              },
                            )
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: InputTextWidget(
                              fieldType: FieldTypes.cvv,
                              label: 'CVV',
                              placeholder: '856',
                              prefixIcon:
                                  'credit-card-edit-light.svg',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: Validation.validateCvv,
                              onSaved: (value) {
                                _cvv = value!;
                              },
                            )
                          ),
                        ]
                      ),
                    ]
                  ),
              )
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButtonWidget(
                text: 'Add Card',
                onClicked: _submitAddForm
              ),
            ),
          ),
        ),
      ),
    );
  }
}
