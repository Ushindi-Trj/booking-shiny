part of 'business_bloc.dart';

@immutable
class BusinessEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleFavoriteRequested extends BusinessEvent {
  ToggleFavoriteRequested({required this.isFavorite, required this.businessId});

  final bool isFavorite;
  final String businessId;

  @override
  List<Object?> get props => [];
}

class AddToCartRequested extends BusinessEvent {
  final String business;
  final String serviceId;
  final String serviceName;
  final DurationModel duration;
  final String? promotionId;

  AddToCartRequested({
    required this.business,
    required this.serviceId,
    required this.serviceName,
    required this.duration,
    this.promotionId
  });

  @override
  List<Object> get props => [business, serviceId, serviceName, duration];
}