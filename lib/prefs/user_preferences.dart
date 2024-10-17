import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences prefs;

  static const keyIsLoggedIn = 'isLoggedIn';

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    await prefs.setBool(keyIsLoggedIn, isLoggedIn);
  }

  static bool isUserLoggedIn() {
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }
}
