part of 'user_cubit.dart';

@immutable
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitialState extends UserState {}

/*
  Add new card
*/
class AddCardLoading extends UserState {}

class AddCardDone extends UserState {}

class AddCardError extends UserState {
  AddCardError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}


/*
  Update the card information
*/
class UpdateCardLoading extends UserState {}

class UpdateCardDone extends UserState {}

class UpdateCardError extends UserState {
  UpdateCardError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}


/*
  Fetch all user's cards
*/
class FetchCardsLoading extends UserState {}

class FetchCardsError extends UserState {
  FetchCardsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class FetchCardsDone extends UserState {
  FetchCardsDone({required this.paymentMethods});

  final List<PaymentMethodModel> paymentMethods;

  @override
  List<Object?> get props => [paymentMethods];
}

/*
  Set default card
*/
class SetDefaultCardLoading extends UserState {}

class SetDefaultCardDone extends UserState {}

class SetDefaultCardError extends UserState {
  SetDefaultCardError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/*
  Remove the card
*/
class DeleteCardLoading extends UserState {}

class DeleteCardDone extends UserState {}

class DeleteCardError extends UserState {
  DeleteCardError({required this.message});

  final String message;

  @override
  List<Object?> get props => [];
}