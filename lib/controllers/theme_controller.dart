// lib/controllers/theme_controller.dart

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_model.dart';

class ThemeController extends GetxController {
  ThemeModel themeModel = ThemeModel(theme: 'light');

  @override
  void onInit() {
    super.onInit();
    loadPrefs();
  }

  void themeToggle(String? value) {
    if (value != null) {
      themeModel.theme.value = value;
      setPrefs();
    }
  }

  Future<void> loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedTheme = prefs.getString("theme") ?? 'light';
    themeModel.theme.value = savedTheme;
  }

  Future<void> setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", themeModel.theme.value);
  }
}
