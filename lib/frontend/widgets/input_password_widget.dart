import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booking_shiny/utils/utils.dart';

class InputPasswordWidget extends StatefulWidget {
  const InputPasswordWidget({
    super.key,
    required this.label,
    required this.placeholder,

    this.validator,
    this.onSaved,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final String placeholder;
  final TextInputAction textInputAction;

  final void Function(String?)? onSaved;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  @override
  State<InputPasswordWidget> createState() => _InputPasswordWidgetState();
}

class _InputPasswordWidgetState extends State<InputPasswordWidget> {
  late bool _isFieldEmpty = true;
  late bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final String suffixIcon = (!_isFieldEmpty && !_obscureText) ? 'eye-slash.svg' : 'eye.svg';
    final colorFilter = _isFieldEmpty ? Secondary.grey1 : Theme.of(context).colorScheme.surface;

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

                if (value.isEmpty) {
                  _obscureText = true;
                }
              });
            },
            validator: widget.validator,
            onSaved: widget.onSaved,
            onFieldSubmitted: widget.onSubmitted,
            textInputAction: widget.textInputAction,
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              height: 1.6,
              fontWeight: FontWeight.normal
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              prefixIconConstraints: const BoxConstraints(minWidth: 52),
              suffixIconConstraints: const BoxConstraints(minWidth: 52),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              hintStyle: const TextStyle(color: Secondary.grey1, fontWeight: FontWeight.normal),
              prefixIcon: SvgPicture.asset(
                'assets/icons/password.svg',
                colorFilter: ColorFilter.mode(colorFilter, BlendMode.srcIn),
              ),
              suffixIcon: GestureDetector(
                onTap: _isFieldEmpty ? null : () => setState(() {
                  _obscureText = !_obscureText;
                }),
                child: SvgPicture.asset(
                  'assets/icons/$suffixIcon',
                  colorFilter: ColorFilter.mode(colorFilter, BlendMode.srcIn),
                ),
              ),
              border: _inputBorder(),
              enabledBorder: _inputBorder(),
              focusedBorder: _inputBorder(),
            ),
          ),
        )
      ]
    );
  }

  OutlineInputBorder _inputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primaryContainer)
  );
}
