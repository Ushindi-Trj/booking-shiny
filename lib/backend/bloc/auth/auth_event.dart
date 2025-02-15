part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class SignoutRequested extends AuthEvent {}
class CheckAuthRequested extends AuthEvent {}
class GoogleLoginRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  const LoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  const SignupRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.confirm,
  });

  final String username;
  final String email;
  final String password;
  final String confirm;

  @override
  List<Object?> get props => [username, email, password, confirm];
}
