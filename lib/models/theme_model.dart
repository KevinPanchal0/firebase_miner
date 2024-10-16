// lib/models/theme_model.dart

import 'package:get/get.dart';

class ThemeModel {
  RxString theme;

  ThemeModel({required String theme}) : theme = theme.obs;
}
