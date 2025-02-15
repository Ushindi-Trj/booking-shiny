import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/data/repositories/repositories.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  BusinessBloc({required this.repository}): super(BusinessInitialState())
  {
    on<ToggleFavoriteRequested>(_toggleFavoriteRequested);
    on<AddToCartRequested>(_toggleServiceToCart);
  }

  final BusinessRepository repository;

  //  Add/Remove business to favorite
  void _toggleFavoriteRequested(ToggleFavoriteRequested event, emit) async {
    try {
      await repository.toggleFavorite(event.businessId, event.isFavorite);
    } catch(error) {
      print(error.toString());
    }
  }

  //  Add/Remove service to cart
  void _toggleServiceToCart(AddToCartRequested event, emit) async {
    try {
      await repository.addServiceToCart(
        businessId: event.business,
        serviceId: event.serviceId,
        serviceName: event.serviceName,
        duration: event.duration.duration,
        price: event.duration.price,
        promotionId: event.promotionId
      );
    } catch(error) {
      print(error);
    }
  }
}