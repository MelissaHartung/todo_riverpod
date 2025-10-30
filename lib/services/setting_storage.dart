import 'package:shared_preferences/shared_preferences.dart';

class Settingstorage {
  Future<void> saveSettings(bool isDarkmode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkmode);
  }

  Future<bool> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? true;
  }
}
