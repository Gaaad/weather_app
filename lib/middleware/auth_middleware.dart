import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (prefs?.getBool("seen") == true) {
      return RouteSettings(name: "/home");
    } else {
      return null;
    }
  }

  Future<String> setVal() async {
    return await getPrefs(key: "intro");
  }
}
