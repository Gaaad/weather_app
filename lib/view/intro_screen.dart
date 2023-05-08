import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/controller/places_controller.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/model/reusable_components.dart';

import '../controller/indicator_controller.dart';
import '../model/constants.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key}) {
    getPosition();
  }

  IndicatorController indicatorController = Get.put(IndicatorController());

  final PageController _pageController = PageController();

  PlaceController placeController = Get.put(PlaceController());

  TextEditingController firstPlace = TextEditingController();
  TextEditingController secondPlace = TextEditingController();
  TextEditingController thirdPlace = TextEditingController();

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
      resizeToAvoidBottomInset: true,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        backgroundColor(),
        //screen
        SingleChildScrollView(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 650,
                  width: 400,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (value) {
                      indicatorController.indx.value = value;
                    },
                    children: [
                      buildFirstPage(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              vSpace(height: 120),
                              //image
                              Center(
                                child: Container(
                                  width: 300,
                                  alignment: Alignment.center,
                                  child: Image.asset("assets/images/logo2.png"),
                                ),
                              ),
                              vSpace(),
                              Text(
                                "Choose Places",
                                style: h2(),
                              ),
                              vSpace(),
                              Column(
                                children: [
                                  buildCity(
                                    placeController: placeController,
                                    textEditingController: firstPlace,
                                    index: 0,
                                  ),
                                  vSpace(),
                                  buildCity(
                                    placeController: placeController,
                                    textEditingController: secondPlace,
                                    index: 1,
                                  ),
                                  vSpace(),
                                  buildCity(
                                    placeController: placeController,
                                    textEditingController: thirdPlace,
                                    index: 2,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //dots and button
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            HexColor("002B5B"),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        onPressed: () {
                          prefs?.setBool("seen", true);
                          if (indicatorController.indx.value < 1) {
                            indicatorController.indx.value++;
                            _pageController
                                .jumpToPage(indicatorController.indx.value);
                          } else {
                            indicatorController.indx.value = 0;
                            if (placeController.place[0].value.isNotEmpty &&
                                placeController.place[1].value.isNotEmpty &&
                                placeController.place[2].value.isNotEmpty) {
                              Get.offAllNamed("/home");
                            } else {
                              Get.defaultDialog(
                                title: "Wrong places!",
                                middleText: "Please enter all cities again",
                                radius: 5,
                                backgroundColor: HexColor("1A5F7A"),
                              );
                              indicatorController.indx.value = 1;
                            }
                          }
                        },
                        child: const Text("Next"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      alignment: Alignment.bottomCenter,
                      child: GetX<IndicatorController>(builder: (context) {
                        return AnimatedSmoothIndicator(
                          activeIndex: indicatorController.indx.value,
                          count: 2,
                          effect: WormEffect(
                            activeDotColor: HexColor("0E8388"),
                            dotColor: HexColor("002B5B"),
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 10,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCity({
    required PlaceController placeController,
    required int index,
    required TextEditingController textEditingController,
  }) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: textEditingController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          labelText: 'City',
          suffixIcon: Icon(Icons.place),
          border: OutlineInputBorder(),
        ),
      ),
      suggestionsCallback: (query) => _getFilteredCities(query),
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.toString()),
        );
      },
      onSuggestionSelected: (suggestion) async {
        textEditingController.text = suggestion;
        placeController.place[index].value = suggestion;
        setPrefs(key: "place${index + 1}", value: suggestion);
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.black.withOpacity(0.5),
        constraints: const BoxConstraints(
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

  Widget buildFirstPage() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 400,
              height: 400,
              alignment: Alignment.center,
              child: Image.asset("assets/images/logo1.png"),
            ),
          ),
          vSpace(height: 30),
          Column(
            children: [
              Text(
                "Welcome to Gad Storm App",
                style: h2(),
              ),
              vSpace(),
              Text(
                "Lets try the app!",
                style: h3(),
              )
            ],
          ),
          vSpace(height: 60),
        ],
      ),
    );
  }

  getPosition() async {
    bool? services;
    LocationPermission locationPermission;

    locationPermission = await Geolocator.checkPermission();
    services = await Geolocator.isLocationServiceEnabled();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    if (services == false) {
      Geolocator.openLocationSettings();
    }
  }
}
