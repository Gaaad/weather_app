import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/controller/indicator_controller.dart';
import 'package:weather_app/controller/location_controller.dart';
import 'package:weather_app/controller/tempreture_controller.dart';
import 'package:weather_app/locale/locale_controller.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/model/reusable_components.dart';

import '../controller/places_controller.dart';
import '../model/weather_model.dart';
import '../services/weather_service.dart';

// ignore: must_be_immutable
class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key}) {
    getPosition();
  }

  final PageController _pageController = PageController();
  Position? currentLoction;

  IndicatorController indicatorController = Get.put(IndicatorController());
  LocationController locationController = Get.put(LocationController());
  PlaceController placeController = Get.put(PlaceController(), permanent: true);
  MyLocaleController myLocaleController = Get.find();
  TempretureController tempretureController = Get.put(TempretureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawer(context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        backgroundColor(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              indicatorController.indx.value = value;
            },
            children: [
              GetX<LocationController>(builder: (context) {
                if (locationController.isLoading.value) {
                  return Center(
                    child: loadingIndicator(size: 50),
                  );
                } else if (locationController.hasError.value) {
                  print('Error: ${locationController.errorMessage}');
                  return Center(
                    child: Text('Error: ${locationController.errorMessage}'),
                  );
                } else {
                  return buildMyLocationWeather(
                      city: locationController.administrativeArea.value);
                }
              }),
              GetX<PlaceController>(builder: (context) {
                if (placeController.isLoading.value) {
                  return Center(
                    child: loadingIndicator(size: 50),
                  );
                } else if (placeController.hasError.value) {
                  return Center(
                    child: Text('Error: ${locationController.errorMessage}'),
                  );
                } else {
                  return buildSelectedLocationWeather(
                      city: placeController.place[0].value);
                }
              }),
              GetX<PlaceController>(builder: (context) {
                if (placeController.isLoading.value) {
                  return Center(
                    child: loadingIndicator(size: 50),
                  );
                } else if (placeController.hasError.value) {
                  return Center(
                    child: Text('Error: ${locationController.errorMessage}'),
                  );
                } else {
                  return buildSelectedLocationWeather(
                      city: placeController.place[1].value);
                }
              }),
              GetX<PlaceController>(builder: (context) {
                if (placeController.isLoading.value) {
                  return Center(
                    child: loadingIndicator(size: 50),
                  );
                } else if (placeController.hasError.value) {
                  return Center(
                    child: Text('Error: ${locationController.errorMessage}'),
                  );
                } else {
                  return buildSelectedLocationWeather(
                      city: placeController.place[2].value);
                }
              }),
            ],
          ),
        ),
        //dots
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.bottomCenter,
          child: GetX<IndicatorController>(builder: (context) {
            return AnimatedSmoothIndicator(
              activeIndex: indicatorController.indx.value,
              count: 4,
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
    );
  }

  SizedBox buildMyLocationWeather({required String city}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //current tempearature
          FutureBuilder<WeatherData>(
            future: WeatherService().fetchWeatherData(city, 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingIndicator(size: 45);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No data found');
              } else {
                final weather = snapshot.data!;
                return Column(
                  children: [
                    //current temp
                    GetX<TempretureController>(builder: (context) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          hSpace(),
                          Text(
                            tempretureController.isCelisuis.value
                                ? weather.current.tempC.toInt().toString()
                                : weather.current.tempF.toInt().toString(),
                            style: const TextStyle(fontSize: 100),
                          ),
                          Text(
                            tempretureController.isCelisuis.value ? "°C" : "°F",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      );
                    }),
                    vSpace(),
                    //sunrise sunsit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //sunrise
                        Row(
                          children: [
                            const Icon(
                              Icons.sunny,
                              color: Colors.yellow,
                            ),
                            hSpace(),
                            Text(weather.astro.sunrise),
                          ],
                        ),
                        //sunset
                        Row(
                          children: [
                            const Icon(
                              Icons.nightlight,
                              color: Color.fromARGB(255, 7, 52, 88),
                            ),
                            hSpace(),
                            Text(weather.astro.sunset),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
          //today ,tomorow, after
          SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //today
                defaultListTitle(
                  title: "today".tr,
                  icon: Icons.thunderstorm_outlined,
                  trailing: FutureBuilder<WeatherData>(
                    future: WeatherService().fetchWeatherData(city, 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('No data found');
                      } else {
                        final weather = snapshot.data!;
                        return GetX<TempretureController>(builder: (context) {
                          return Text(
                            tempretureController.isCelisuis.value
                                ? "${weather.day.maxTempC.toInt().toString()}°/${weather.day.minTempC.toInt().toString()}°"
                                : "${weather.day.maxTempF.toInt().toString()}°/${weather.day.minTempF.toInt().toString()}°",
                          );
                        });
                      }
                    },
                  ),
                  //on tab
                  onTab: () {
                    Get.bottomSheet(
                      buildBottomSheet(
                        city: city,
                        index: 0,
                        day: "today".tr,
                      ),
                    );
                  },
                ),
                //tomorrow
                defaultListTitle(
                  title: "tomorrow".tr,
                  icon: Icons.wb_sunny_outlined,
                  trailing: FutureBuilder<WeatherData>(
                    future: WeatherService().fetchWeatherData(city, 1),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('No data found');
                      } else {
                        final weather = snapshot.data!;
                        return GetX<TempretureController>(builder: (context) {
                          return Text(
                            tempretureController.isCelisuis.value
                                ? "${weather.day.maxTempC.toInt().toString()}°/${weather.day.minTempC.toInt().toString()}°"
                                : "${weather.day.maxTempF.toInt().toString()}°/${weather.day.minTempF.toInt().toString()}°",
                          );
                        });
                      }
                    },
                  ),
                  onTab: () {
                    Get.bottomSheet(
                      buildBottomSheet(
                        city: city,
                        index: 0,
                        day: "tomorrow".tr,
                      ),
                    );
                  },
                ),
                //after
                defaultListTitle(
                  title: "after".tr,
                  icon: Icons.cloud_outlined,
                  trailing: FutureBuilder<WeatherData>(
                    future: WeatherService().fetchWeatherData(city, 2),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('No data found');
                      } else {
                        final weather = snapshot.data!;
                        return GetX<TempretureController>(builder: (context) {
                          return Text(
                            tempretureController.isCelisuis.value
                                ? "${weather.day.maxTempC.toInt().toString()}°/${weather.day.minTempC.toInt().toString()}°"
                                : "${weather.day.maxTempF.toInt().toString()}°/${weather.day.minTempF.toInt().toString()}°",
                          );
                        });
                      }
                    },
                  ),
                  onTab: () {
                    Get.bottomSheet(
                      buildBottomSheet(
                        city: city,
                        index: 0,
                        day: "after".tr,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          //time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<WeatherData>(
                future: WeatherService().fetchWeatherData(city, 0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingIndicator(size: 45);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data found');
                  } else {
                    final weather = snapshot.data!;
                    return SizedBox(
                      width: 340,
                      height: 101,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 24,
                        separatorBuilder: (BuildContext context, int index) {
                          return hSpace();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          String dateTimeString = weather.hour[index].time;
                          // Get the second part of the split string
                          String timeString = dateTimeString.split(" ")[1];
                          // Matches the time in the format of HH:MM
                          RegExp regExp = RegExp(r"(\d{2}):(\d{2})");
                          // Extract the time portion of the string
                          String? timeOnly = regExp.stringMatch(timeString);
                          return GetX<TempretureController>(builder: (context) {
                            return buildWeatherTime(
                              time: timeOnly!,
                              temperature: tempretureController.isCelisuis.value
                                  ? weather.hour[index].tempC.toInt()
                                  : weather.hour[index].tempF.toInt(),
                              imageUrl: weather.hour[index].icon,
                            );
                          });
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
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
      await getLatAndLong();
    }
    if (services == false) {
      Geolocator.openLocationSettings();
    }
  }

  getLatAndLong() async {
    currentLoction = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLoction!.latitude, currentLoction!.longitude);
  }

  AppBar buildAppBar() {
    return AppBar(
      title: GetX<LocationController>(builder: (context) {
        if (indicatorController.indx.value == 0) {
          return Text(
            locationController.administrativeArea.value.tr,
            style: const TextStyle(letterSpacing: 2),
          );
        } else {
          return Text(
            placeController.place[indicatorController.indx.value - 1].value.tr,
            style: const TextStyle(letterSpacing: 2),
          );
        }
      }),
      backgroundColor: HexColor("002B5B"),
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed("/search");
          },
          icon: const Icon(Icons.search),
        )
      ],
    );
  }

  Drawer buildDrawer(context) {
    return Drawer(
      child: Stack(
        children: [
          //color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HexColor("002B5B"),
                  HexColor("1A5F7A"),
                  HexColor("159895"),
                  HexColor("57C5B6"),
                ],
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                title: Text("menu".tr),
                backgroundColor: HexColor("002B5B"),
                elevation: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    //language
                    defaultListTitle(
                      title: "lang".tr,
                      icon: Icons.settings,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTab: () {
                        Get.defaultDialog(
                          title: "lang".tr,
                          radius: 5,
                          backgroundColor: HexColor("1A5F7A"),
                          content: Column(
                            children: [
                              GetX<MyLocaleController>(builder: (context) {
                                return ListTile(
                                  title: Text("ar".tr),
                                  shape: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  onTap: () {
                                    myLocaleController.changeLocale("ar");
                                  },
                                  tileColor: myLocaleController.isArabic.value
                                      ? HexColor("002B5B")
                                      : null,
                                );
                              }),
                              vSpace(height: 10),
                              GetX<MyLocaleController>(builder: (context) {
                                return ListTile(
                                  title: Text("en".tr),
                                  shape: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  onTap: () {
                                    myLocaleController.changeLocale("en");
                                  },
                                  tileColor: myLocaleController.isArabic.value
                                      ? null
                                      : HexColor("002B5B"),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                    vSpace(height: 10),
                    //cities
                    defaultListTitle(
                      title: "cities".tr,
                      icon: Icons.flag,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTab: () {
                        Get.toNamed("/city");
                      },
                    ),
                    vSpace(height: 10),
                    //temp
                    defaultListTitle(
                      title: "temp".tr,
                      icon: Icons.thermostat_outlined,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTab: () {
                        Get.defaultDialog(
                          title: "temp".tr,
                          radius: 5,
                          backgroundColor: HexColor("1A5F7A"),
                          content:
                              GetX<TempretureController>(builder: (context) {
                            return Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text("c".tr),
                                    shape: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    onTap: () {
                                      tempretureController.isCelisuis.value =
                                          true;
                                      setPrefs(key: "temp", value: "c");
                                    },
                                    tileColor:
                                        tempretureController.isCelisuis.value
                                            ? HexColor("002B5B")
                                            : null,
                                  ),
                                ),
                                hSpace(),
                                Expanded(
                                  child: ListTile(
                                    title: Text("f".tr),
                                    shape: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    onTap: () {
                                      tempretureController.isCelisuis.value =
                                          false;
                                      setPrefs(key: "temp", value: "f");
                                    },
                                    tileColor:
                                        !tempretureController.isCelisuis.value
                                            ? HexColor("002B5B")
                                            : null,
                                  ),
                                ),
                              ],
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          //abdalrhman gad
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            alignment: Alignment.bottomCenter,
            child: Text(
              "me".tr,
              style: TextStyle(
                color: HexColor("002B5B"),
                letterSpacing: 1.25,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  getInitialPlcaes() async {
    placeController.place[0].value = await getPrefs(key: "place1");
    placeController.place[1].value = await getPrefs(key: "place2");
    placeController.place[2].value = await getPrefs(key: "place3");
  }
}
