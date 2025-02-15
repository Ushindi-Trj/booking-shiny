import 'package:bloc/bloc.dart';
import 'package:booking_shiny/data/repositories/repositories.dart' show ThemeModeRepository;

class ThemeModeCubit extends Cubit<bool> {
  ThemeModeCubit({required this.repository, required currentTheme}): super(currentTheme);

  final ThemeModeRepository repository;

  //  Set new theme mode (dark/light)
  Future<void> changeThemeModeRequested(bool isDart) async {
    await repository.changeTheme(isDart);
    emit(isDart);
  }
}