import 'package:bloc/bloc.dart';

class OnboardingCarouselCubit extends Cubit<int> {
  OnboardingCarouselCubit(): super(0);

  onCarouselChanged(int index) {
    emit(index);
  }
}