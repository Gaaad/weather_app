import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class MyLocaleController extends GetxController {
  RxBool isArabic = getPrefs(key: "lang") == "ar" ? true.obs : false.obs;

  Locale initLang = getPrefs(key: "lang") == null
      ? const Locale("en")
      : (getPrefs(key: "lang") == "ar"
          ? const Locale("ar")
          : const Locale("en"));

  void changeLocale(String langCode) {
    Locale locale = Locale(langCode);

    setPrefs(key: "lang", value: langCode);
    Get.updateLocale(locale);
    if (locale == const Locale("ar")) {
      isArabic.value = true;
    } else {
      isArabic.value = false;
    }
  }
}
