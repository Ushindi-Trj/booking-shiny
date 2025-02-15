import 'package:flutter/material.dart';
// import 'package:shiny_booking/packages.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_shiny/backend/bloc/blocs.dart';
import 'package:booking_shiny/backend/cubit/cubits.dart';

import 'package:booking_shiny/utils/utils.dart';
import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _signupForm = GlobalKey<FormState>();
  late String _email;
  late String _username;
  late String _password;
  late String _confirm;

  void _submitSignupForm() {
    FocusScope.of(context).unfocus();
    _signupForm.currentState!.save();

    try {
      context.read<AuthBloc>().add(SignupRequested(
        username: _username,
        email: _email,
        password: _password,
        confirm: _confirm
      ));
    } catch(error) {
      SnackBarWidget.showSnackbarError(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, state) => state is SignupError || state is SignupDone,
      listener: (context, state) {
        if (state is SignupError) {
          SnackBarWidget.showSnackbarError(context: context, message: state.message);
        } else if (state is SignupDone) {
          //  Show the modal to ask user to verify his account or continue in app
          showModalBottomSheet(
            context: context,
            elevation: 0,
            enableDrag: false,
            isDismissible: false,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            barrierColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.46),
            builder: (context) => _SignupBottomSheet()
          );
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
                'Create New Account',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Please create account first before organizing your life.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Form(
                  key: _signupForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputTextWidget(
                        label: 'Full-name',
                        prefixIcon: 'user.svg',
                        placeholder: 'Enter your first and last name',
                        onSaved: (value) {
                          _username = value!;
                        }
                      ),
                      const SizedBox(height: 16),
                      InputTextWidget(
                        label: 'Email Address',
                        prefixIcon: 'message.svg',
                        placeholder: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _email = value!;
                        }
                      ),
                      const SizedBox(height: 16),
                      InputPasswordWidget(
                        label: 'Password',
                        placeholder: 'Enter your password',
                        onSaved: (value) {
                          _password = value!;
                        }
                      ),
                      const SizedBox(height: 16),
                      InputPasswordWidget(
                        label: 'Confirmation',
                        placeholder: 'Confirm your password',
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submitSignupForm(),
                        onSaved: (value) {
                          _confirm = value!;
                        }
                      ),
                    ]
                  )
                ),
              ),
        
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, state) {
                  return state is SignupLoading || state is SignupDone || state is SignupError;
                },
                builder: (context, state) {
                  final bool isLoading = state is SignupLoading;
                  final double width = (state is SignupLoading) ? 56 : MediaQuery.of(context).size.width - 40;

                  return Center(
                    child: AnimatedContainer(
                      width: width,
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 360),
                      child: ElevatedButtonWidget(
                        text: 'Create Account',
                        isLoading: isLoading,
                        onClicked: isLoading ? null : _submitSignupForm,
                      ),
                    ),
                  );
                }
              ),
              const CredentialAuthButtonsWidget(
                text1: 'Sign Up using Google',
                text2: 'Sign Up using Facebook',
              )
            ],
          ),
        ),
      ),
    );
  }
}

//  Bottom sheet to show when user created new account successfully
class _SignupBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, bool>( // Get the current theme
      buildWhen: (prev, state) => false,
      builder: (context, themeIsDark) {
        final Color darkThemeColor = themeIsDark ? const Color(0xff4C5151) : const Color(0xffD8DBE5);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [BoxShadow(
              blurRadius: 40,
              spreadRadius: 1.2,
              offset: const Offset(0, -5),
              color: Theme.of(context).colorScheme.secondary
            )]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  color: darkThemeColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(40)
                )
              ),
              const SizedBox(height: 32),
              Container(
                width: 120, height: 120,
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: themeIsDark ? Support.dBlack2 : Secondary.lightGrey3,
                  shape: BoxShape.circle
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 28),
                  padding: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Column(children: [
                    SvgPicture.asset('assets/icons/tick-circle.svg'),
                    const SizedBox(height: 6),
                    Container(
                      height: 6, width: 52,
                      decoration: BoxDecoration(
                        color: darkThemeColor,
                        borderRadius: BorderRadius.circular(40)
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 76, height: 34,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: darkThemeColor.withOpacity(0.36),
                        borderRadius: BorderRadius.circular(4)
                      ),
                    )
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Create Account Success',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Congratulation! You successfully created your account. we have sent an email to verify your account.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),
              ElevatedButtonWidget(
                text: 'Verify Account',
                onClicked: () {
                  //  TODO open mail app and verify account
                }
              ),
              const SizedBox(height: 16),
              OutlinedButtonWidget(
                onClicked: () {
                  context.read<AuthBloc>().add(CheckAuthRequested());
                  context.pop();
                },
                text: 'Continue',
              )
            ],
          ),
        );
      }
    );
  }
}