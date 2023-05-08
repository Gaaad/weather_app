import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/locale/local.dart';
import 'package:weather_app/locale/locale_controller.dart';
import 'package:weather_app/middleware/auth_middleware.dart';
import 'package:weather_app/view/intro_screen.dart';
import 'package:weather_app/view/search_screen.dart';
import 'package:weather_app/view/weather_screen.dart';

import 'view/cities_screen.dart';

setPrefs({required String key, required String value}) {
  prefs?.setString(key, value);
}

getPrefs({required String key}) {
  return prefs?.getString(key);
}

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MyLocaleController myLocaleController = Get.put(MyLocaleController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      locale: myLocaleController.initLang,
      translations: MyLocal(),
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => IntroScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(name: "/home", page: () => WeatherScreen()),
        GetPage(name: "/search", page: () => SearchScreen()),
        GetPage(name: "/city", page: () => CitiesScreen()),
      ],
    );
  }
}
