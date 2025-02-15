part of 'business_bloc.dart';

@immutable
abstract class BusinessState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BusinessInitialState extends BusinessState {}