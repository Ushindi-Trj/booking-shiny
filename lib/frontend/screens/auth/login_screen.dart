import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:booking_shiny/backend/bloc/blocs.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  late String _email;
  late String _password;

  void _submitLoginForm() {
    FocusScope.of(context).unfocus();
    _loginForm.currentState!.save();

    try {
      context.read<AuthBloc>().add(LoginRequested(email: _email, password: _password));
    } catch(error) {
      SnackBarWidget.showSnackbarError(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, state) => state is LoginError || state is LoginDone,
      listener: (context, state) {
        if (state is LoginError) {
          SnackBarWidget.showSnackbarError(context: context, message: state.message);
        } else if (state is LoginDone) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 64,
          leading: const PopButtonWidget()
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login to Your Account',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Please log in to access your Shiny account.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Form(
                  key: _loginForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputTextWidget(
                        label: 'Email Address',
                        prefixIcon: 'message.svg',
                        placeholder: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _email = value!;
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: InputPasswordWidget(
                          label: 'Password',
                          placeholder: 'Enter your password',
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _submitLoginForm(),
                          onSaved: (value) {
                            _password = value!;
                          }
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            //  TODO: Password forgoten
                          },
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Primary.darkGreen1),
                          )
                        ),
                      ),
                    ]
                  )
                ),
              ),
        
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, state) {
                  return state is LoginLoading || state is LoginDone || state is LoginError;
                },
                builder: (context, state) {
                  final bool isLoading = state is LoginLoading;
                  final double width = (state is LoginLoading) ? 56 : MediaQuery.of(context).size.width - 40;

                  return Center(
                    child: AnimatedContainer(
                      width: width,
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 360),
                      child: ElevatedButtonWidget(
                        isLoading: isLoading,
                        text: 'Login',
                        onClicked: isLoading ? null : _submitLoginForm,
                      ),
                    ),
                  );
                }
              ),
              const CredentialAuthButtonsWidget(
                text1: 'Login using Google',
                text2: 'Login using Facebook',
              )
            ],
          ),
        ),
      ),
    );
  }
}