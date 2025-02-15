part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends AuthState {}
class Authenticated extends AuthState {}
class Unauthenticated extends AuthState {}

class LoginLoading extends AuthState {}
class LoginDone extends AuthState {}
class LoginError extends AuthState {
  LoginError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class SignupLoading extends AuthState {}
class SignupDone extends AuthState {}
class SignupError extends AuthState {
  SignupError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class CredentialLoginDone extends AuthState {}
class CredentialLoginError extends AuthState {
  CredentialLoginError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
