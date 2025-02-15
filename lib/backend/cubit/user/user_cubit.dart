import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart' show UserRepository;

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.repository}): super(UserInitialState());

  final UserRepository repository;

  void addNewCardRequest({holderName, cardNumber, expiryYear, expiryMonth, cvv}) async {
    try {
      emit(AddCardLoading());
      await repository.addNewCard(
        holder: holderName,
        number: cardNumber,
        year: expiryYear,
        month: expiryMonth,
        cvv: cvv
      );
      emit(AddCardDone());
    } catch(error) {
      emit(AddCardError(message: error.toString()));
    }
  }

  void updateCardRequest({paymentMethodId, holderName, expiryYear, expiryMonth}) async {
    try {
      emit(UpdateCardLoading());
      await repository.updatecard(
        cardId: paymentMethodId,
        holder: holderName,
        expMonth: expiryMonth,
        expYear: expiryYear
      );
      emit(UpdateCardDone());
    } catch(error) {
      emit(UpdateCardError(message: error.toString()));
    }
  }

  void fecthCardsRequest() async {
    try {
      emit(FetchCardsLoading());
      final paymentMethods = await repository.fetchCards();
      emit(FetchCardsDone(paymentMethods: paymentMethods));
    } catch(error) {
      emit(FetchCardsError(message: error.toString()));
    }
  }

  void setDeaultCardRequest(String paymentMethodId) async {
    try {
      emit(SetDefaultCardLoading());
      await repository.setDefaultCard(paymentMethodId);
      emit(SetDefaultCardDone());
    } catch(error) {
      emit(SetDefaultCardError(message: error.toString()));
    }
  }

  void deleteCardRequest(String id) async {
    try {
      emit(DeleteCardLoading());
      await repository.deleteCard(cardId: id);
      emit(DeleteCardDone());
    } catch(error) {
      emit(DeleteCardError(message: error.toString()));
    }
  }
}