import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking_shiny/backend/bloc/blocs.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class CredentialAuthButtonsWidget extends StatelessWidget {
  const CredentialAuthButtonsWidget(
      {super.key, required this.text1, required this.text2});

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, state) => state is CredentialLoginError || state is CredentialLoginDone,
      listener: (context, state) {
        if (state is CredentialLoginError) {
          SnackBarWidget.showSnackbarError(context: context, message: state.message);
        } else if (state is CredentialLoginDone) {
          context.pop();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.transparent,
                      Theme.of(context).colorScheme.primaryContainer
                    ])),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Or login using',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        height: 1.6,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Colors.transparent,
                    ])),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButtonWidget(
            onClicked: () {
              BlocProvider.of<AuthBloc>(context).add(GoogleLoginRequested());
            },
            icon: 'google.svg',
            text: text1,
          ),
          const SizedBox(height: 16),
          OutlinedButtonWidget(
            onClicked: () {},
            icon: 'facebook.svg',
            text: text2,
          ),
        ],
      ),
    );
  }
}
