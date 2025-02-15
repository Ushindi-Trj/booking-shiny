import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:booking_shiny/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}): super(
    (FirebaseAuth.instance.currentUser != null) ? Authenticated() : Unauthenticated()
  ) {
    on<CheckAuthRequested>(_checkAuthentication);
    on<SignoutRequested>(_signoutRequested);

    on<LoginRequested>(_loginRequested);
    on<SignupRequested>(_signupRequested);
    on<GoogleLoginRequested>(_googleLoginRequested);
  }

  final AuthRepository repository;

  void _checkAuthentication(event, emit) {
    if (FirebaseAuth.instance.currentUser != null) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void _signoutRequested(event, emit) {
    FirebaseAuth.instance.signOut();
    emit(Unauthenticated());
  }

  void _loginRequested(LoginRequested event, emit) async {
    try{
      emit(LoginLoading());
      await Future.delayed(const Duration(seconds: 2));
      await repository.login(event.email, event.password);
      add(CheckAuthRequested());
      emit(LoginDone());
    } catch(error) {
      emit(LoginError(message: error.toString()));
    }
  }

  void _signupRequested(SignupRequested event, emit) async {
    try {
      emit(SignupLoading());
      await Future.delayed(const Duration(seconds: 2));
      await repository.signup(event.username, event.email, event.password, event.confirm);
      emit(SignupDone());
    } catch(error) {
      emit(SignupError(message: error.toString()));
    }
  }

  void _googleLoginRequested(event, emit) async {
    try {
      await repository.loginWithGoogle();
      add(CheckAuthRequested());
      emit(CredentialLoginDone());
    } catch(error) {
      emit(CredentialLoginError(message: error.toString()));
    }
  }
}