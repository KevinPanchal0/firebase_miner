import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_miner/controllers/theme_controller.dart';
import 'package:firebase_miner/utils/theme.dart';
import 'package:firebase_miner/views/screens/auth_screens/sign_in_page.dart';
import 'package:firebase_miner/views/screens/auth_screens/sign_up_page.dart';
import 'package:firebase_miner/views/screens/home_page.dart';
import 'package:firebase_miner/views/screens/pages/chat_page.dart';
import 'package:firebase_miner/views/screens/pages/settings_page.dart';
import 'package:firebase_miner/views/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());
    return Obx(
      () {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash_screen',
          theme: GlobalTheme().lightTheme,
          darkTheme: GlobalTheme().darkTheme,
          themeMode: (themeController.themeModel.theme.value == 'light')
              ? ThemeMode.light
              : (themeController.themeModel.theme.value == 'dark')
                  ? ThemeMode.dark
                  : ThemeMode.system,
          getPages: [
            GetPage(name: '/', page: () => const HomePage()),
            GetPage(name: '/splash_screen', page: () => const SplashScreen()),
            GetPage(name: '/sign_in', page: () => const SignInPage()),
            GetPage(name: '/sign_up', page: () => const SignUpPage()),
            GetPage(name: '/settings_page', page: () => const SettingsPage()),
            GetPage(name: '/chat_page', page: () => const ChatPage()),
          ],
        );
      },
    );
  }
}
