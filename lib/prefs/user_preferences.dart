import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;

  static const _keyIsLoggedIn = 'isLoggedIn';

  static Future<void> init() async {
    // This is the function you're asking about
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  static bool isUserLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
