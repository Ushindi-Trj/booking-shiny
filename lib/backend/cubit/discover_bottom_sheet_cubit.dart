import 'package:bloc/bloc.dart';

class DiscoverBottomSheetCubit extends Cubit<bool> {
  DiscoverBottomSheetCubit(): super(true);

  void slidingChanged(double position) {
    emit(position > 0.9);
  }
}