import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/locale/locale_controller.dart';

class LocationController extends GetxController {
  final RxString administrativeArea = ''.obs;

  final RxBool isLoading = true.obs;

  final RxBool hasError = false.obs;

  final RxString errorMessage = ''.obs;

  MyLocaleController myLocaleController = Get.put(MyLocaleController());

  @override
  void onInit() {
    super.onInit();
    _getLocation();
  }

  void _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: myLocaleController.isArabic.value ? "ar" : 'en_US',
      );
      if (placemarks.isNotEmpty) {
        //to get the first word only of the city name
        String country = placemarks[0].administrativeArea ?? '';
        List<String> words = country.split(' ');
        administrativeArea.value = words.isNotEmpty ? words[0] : '';
      }
      isLoading.value = false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print(e.toString());
      isLoading.value = false;
    }
  }
}
