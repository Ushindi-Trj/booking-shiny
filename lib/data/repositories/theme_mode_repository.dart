import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeRepository {
  Future<bool> getCurrentMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? theme = prefs.getBool('theme');
    return theme ?? false;
  }

  Future<void> changeTheme(bool isDark) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('theme', isDark);
  }
}