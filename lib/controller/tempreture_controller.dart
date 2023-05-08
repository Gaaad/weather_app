import 'package:get/get.dart';
import 'package:weather_app/main.dart';

class TempretureController extends GetxController {
  RxBool isCelisuis = true.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (await getPrefs(key: "temp") == "c") {
      isCelisuis.value = true;
    } else {
      isCelisuis.value = false;
    }
  }
}
