//  This is the input text that contains initial value

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_cvc_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';

import 'package:booking_shiny/data/models/models.dart' show FieldTypes;

class InputTextWidget extends StatefulWidget {
  const InputTextWidget({
    super.key,
    required this.label,
    required this.placeholder,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.fieldType,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.onSubmitted
  });

  final FieldTypes? fieldType;

  final String? initialValue;
  final String label;
  final String placeholder;
  final String prefixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;


  final void Function(String?)? onSaved;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  late bool _isFieldEmpty = true;
  String? _errorText;

  @override
  void didChangeDependencies() {
    if (widget.initialValue != null) {
      setState(() {
        _isFieldEmpty = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                _isFieldEmpty = value.isEmpty;
                _errorText = null;
              });
            },
            validator: widget.validator==null ? null : (value) {
              setState(() {
                _errorText = widget.validator!(value);
              });
              return null;
            },
            onSaved: widget.onSaved,
            onFieldSubmitted: widget.onSubmitted,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: _inputFormaters(),
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              height: 1.6,
              fontWeight: FontWeight.normal
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              prefixIconConstraints: const BoxConstraints(minWidth: 52),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              hintStyle: const TextStyle(color: Secondary.grey1, fontWeight: FontWeight.normal),
              prefixIcon: SvgPicture.asset(
                'assets/icons/${widget.prefixIcon}',
                colorFilter: ColorFilter.mode(
                  _isFieldEmpty ? Secondary.grey1 : Theme.of(context).colorScheme.surface,
                  BlendMode.srcIn
                ),
              ),
              errorText: _errorText,
              border: _inputBorder(),
              enabledBorder: _inputBorder(),
              focusedBorder: _inputBorder(),
              errorBorder: _inputErrorBorder(),
              focusedErrorBorder: _inputErrorBorder(),
              errorStyle: const TextStyle(fontSize: 14, height: 1.3, color: Support.red2),
            ),
          ),
        )
      ]
    );
  }

  //  Create a formaters for credit card, expiry dated, etc...
  List<TextInputFormatter>? _inputFormaters() {
    if (widget.fieldType == FieldTypes.creditCard) {
      return [
        LengthLimitingTextInputFormatter(19),
        MaskedInputFormatter(
          "#### #### #### ####",
          allowedCharMatcher: RegExp(r'[0-9]+'),
        ),
      ];
    } else if (widget.fieldType == FieldTypes.expiryDate) {
      return [
        CreditCardExpirationDateFormatter()
      ];
    } else if (widget.fieldType == FieldTypes.cvv) {
      return [
        CreditCardCvcInputFormatter()
      ];
    }
    return null;
  }

  OutlineInputBorder _inputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primaryContainer)
  );
  
  OutlineInputBorder _inputErrorBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: const BorderSide(width: 1.5, color: Support.red2)
  );
}
