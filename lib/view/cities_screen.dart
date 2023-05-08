import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/model/constants.dart';
import 'package:weather_app/model/reusable_components.dart';

import '../controller/location_controller.dart';
import '../controller/places_controller.dart';
import '../controller/tempreture_controller.dart';
import '../model/weather_model.dart';
import '../services/weather_service.dart';

class CitiesScreen extends StatelessWidget {
  CitiesScreen({super.key});

  LocationController locationController = Get.find();
  PlaceController placeController = Get.find();

  TextEditingController firstPlace = TextEditingController();
  TextEditingController secondPlace = TextEditingController();
  TextEditingController thirdPlace = TextEditingController();

  TempretureController tempretureController = Get.find();

  List<String> cities = [
    'Tokyo',
    'New York',
    'London',
    'Paris',
    'Beijing',
    'Shanghai',
    'Hong Kong',
    'Moscow',
    'Dubai',
    'Singapore',
    'Sydney',
    'Los Angeles',
    'Toronto',
    'San Francisco',
    'Seoul',
    'Berlin',
    'Madrid',
    'Rome',
    'Rio de Janeiro',
    'Istanbul',
    'Cairo',
    'Alexandria',
    'Giza',
    'Shubra El-Kheima',
    'Port Said',
    'Suez',
    'Luxor',
    'Mansoura',
    'Tanta',
    'Asyut',
    'Ismailia',
    'Faiyum',
    'Zagazig',
    'Aswan',
    'Damietta',
    'Minya',
    'Beni Suef',
    'Qena',
    'Sohag',
    'Hurghada'
  ];

  List<String> _getFilteredCities(String query) {
    return cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Stack buildBody() {
    return Stack(
      children: [
        backgroundColor(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildMyCity(city: locationController.administrativeArea.value),
              vSpace(height: 10),
              buildCity(placeController: placeController, index: 0),
              vSpace(height: 10),
              buildCity(placeController: placeController, index: 1),
              vSpace(height: 10),
              buildCity(placeController: placeController, index: 2),
              vSpace(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      HexColor("002B5B"),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    firstPlace.text = "";
                    secondPlace.text = "";
                    thirdPlace.text = "";
                    Get.bottomSheet(
                      buildBottomSheet(),
                    );
                  },
                  child: Text("cp".tr),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  SizedBox buildBottomSheet() {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          backgroundColor(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 500,
                child: Column(
                  children: [
                    buildChangeCity(
                      placeController: placeController,
                      index: 0,
                      textEditingController: firstPlace,
                    ),
                    vSpace(),
                    buildChangeCity(
                      placeController: placeController,
                      index: 1,
                      textEditingController: secondPlace,
                    ),
                    vSpace(),
                    buildChangeCity(
                      placeController: placeController,
                      index: 2,
                      textEditingController: thirdPlace,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildMyCity({required String city}) {
    return Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: HexColor("002B5B").withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<WeatherData>(
            future: WeatherService().fetchWeatherData(city, 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: loadingIndicator(size: 45));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No data found');
              } else {
                final weather = snapshot.data!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "loc".tr,
                              style: h2(),
                            ),
                            vSpace(height: 5),
                            Text(city.tr),
                          ],
                        ),
                        Text(weather.current.weatherStateName),
                      ],
                    ),
                    GetX<TempretureController>(builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tempretureController.isCelisuis.value
                                    ? "${weather.current.tempC.toInt()}"
                                    : "${weather.current.tempF.toInt()}",
                                style: const TextStyle(fontSize: 55),
                              ),
                              const Text(
                                "°",
                                style: TextStyle(fontSize: 40),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                tempretureController.isCelisuis.value
                                    ? "H: ${weather.day.maxTempC.toInt()}"
                                    : "H: ${weather.day.maxTempF.toInt()}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              hSpace(width: 5),
                              Text(
                                tempretureController.isCelisuis.value
                                    ? "L: ${weather.day.minTempC.toInt()}"
                                    : "L: ${weather.day.minTempF.toInt()}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              hSpace(),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                );
              }
            },
          ),
        ));
  }

  Container buildCity(
      {required PlaceController placeController, required int index}) {
    return Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: HexColor("002B5B").withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GetX<PlaceController>(builder: (context) {
            return FutureBuilder<WeatherData>(
              future: WeatherService()
                  .fetchWeatherData(placeController.place[index].value, 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: loadingIndicator(size: 45));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No data found');
                } else {
                  final weather = snapshot.data!;
                  String dateTimeString = weather.current.lastUpdated;
                  // Get the second part of the split string
                  String timeString = dateTimeString.split(" ")[1];
                  // Matches the time in the format of HH:MM
                  RegExp regExp = RegExp(r"(\d{2}):(\d{2})");
                  // Extract the time portion of the string
                  String? timeOnly = regExp.stringMatch(timeString);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                placeController.place[index].value.tr,
                                style: h2(),
                              ),
                              vSpace(height: 5),
                              Text(timeOnly!),
                            ],
                          ),
                          Text(weather.current.weatherStateName),
                        ],
                      ),
                      GetX<TempretureController>(builder: (context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tempretureController.isCelisuis.value
                                      ? "${weather.current.tempC.toInt()}"
                                      : "${weather.current.tempF.toInt()}",
                                  style: const TextStyle(fontSize: 55),
                                ),
                                const Text(
                                  "°",
                                  style: TextStyle(fontSize: 40),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  tempretureController.isCelisuis.value
                                      ? "H: ${weather.day.maxTempC.toInt()}"
                                      : "H: ${weather.day.maxTempF.toInt()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                hSpace(width: 5),
                                Text(
                                  tempretureController.isCelisuis.value
                                      ? "L: ${weather.day.minTempC.toInt()}"
                                      : "L: ${weather.day.minTempF.toInt()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                hSpace(),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  );
                }
              },
            );
          }),
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        "places".tr,
        style: const TextStyle(letterSpacing: 2),
      ),
      backgroundColor: HexColor("002B5B"),
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget buildChangeCity({
    required PlaceController placeController,
    required int index,
    required TextEditingController textEditingController,
  }) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: textEditingController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "${"change".tr}"
              " ${placeController.place[index].value.tr} "
              "${"to".tr}",
          suffixIcon: const Icon(Icons.place),
          border: const OutlineInputBorder(),
        ),
      ),
      suggestionsCallback: (query) => _getFilteredCities(query),
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.toString()),
        );
      },
      onSuggestionSelected: (suggestion) {
        textEditingController.text = suggestion;
        placeController.place[index].value = suggestion;
        setPrefs(key: "place${index + 1}", value: suggestion);
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.black.withOpacity(0.5),
        constraints: const BoxConstraints(
          minHeight: 100,
          maxHeight: 200,
        ),
      ),
      onSaved: (newValue) {
        placeController.place[index].value = newValue!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter a valid city";
        } else {
          return null;
        }
      },
    );
  }
}
