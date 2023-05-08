import 'package:get/get.dart';

import '../main.dart';

class PlaceController extends GetxController {
  List<RxString> place = ["".obs, "".obs, "".obs];

  final RxBool isLoading = true.obs;

  final RxBool hasError = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getInitialPlcaes();
  }

  getInitialPlcaes() async {
    try {
      place[0].value = await getPrefs(key: "place1");
      place[1].value = await getPrefs(key: "place2");
      place[2].value = await getPrefs(key: "place3");
      if (place[0].value.isEmpty &&
          place[1].value.isEmpty &&
          place[2].value.isEmpty) {
        isLoading.value = false;
        hasError.value = true;
        throw Exception("Empty shared prefs");
      }
      isLoading.value = false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }
}
