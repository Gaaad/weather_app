import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weather_app/controller/tempreture_controller.dart';
import 'package:weather_app/model/weather_model.dart';

import '../services/weather_service.dart';
import 'constants.dart';

TempretureController tempretureController = Get.find();

vSpace({double height = 20}) {
  return SizedBox(height: height);
}

hSpace({double width = 10}) {
  return SizedBox(width: width);
}

Widget defaultListTitle({
  required String title,
  required IconData icon,
  Function()? onTab,
  Widget? trailing,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      title: Text(title, style: h3()),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTab,
    ),
  );
}

class Themes {
  static ThemeData customDarkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        fontSize: 20,
      ),
      elevation: 0,
      color: Colors.black,
      toolbarTextStyle: TextStyle(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.yellow,
            decorationColor: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
  );

  static ThemeData customLightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        fontSize: 20,
      ),
      elevation: 0,
      color: Colors.white,
      toolbarTextStyle: TextStyle(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.black),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}

defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required Function(String val) OnSubmitt,
  Function()? onTab,
  required IconData? prefixIcon,
  required String? label,
  TextStyle? labelStyle,
  TextAlign? labelAlign,
  // ignore: use_function_type_syntax_for_parameters
  required String? validate(String? val),
  IconData? suffixIcon,
  bool isPassword = false,
  void Function()? suffixOnPressed,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: isPassword,
    onFieldSubmitted: OnSubmitt,
    onTap: onTab,
    validator: validate,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon != null
          ? IconButton(onPressed: suffixOnPressed, icon: Icon(suffixIcon))
          : null,
      label: Text(label!, style: labelStyle, textAlign: labelAlign),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

SizedBox buildSelectedLocationWeather({required String city}) {
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
                      index: 1,
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
                      index: 2,
                      day: "after".tr,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        //time
        buildTempTime(city, 0),
      ],
    ),
  );
}

Row buildTempTime(String city, int index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      FutureBuilder<WeatherData>(
        future: WeatherService().fetchWeatherData(city, index),
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
                        imageUrl: weather.hour[index].icon);
                  });
                },
              ),
            );
          }
        },
      ),
    ],
  );
}

Widget buildWeatherTime({
  required String time,
  required int temperature,
  required String imageUrl,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        time,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      vSpace(height: 5),
      Text(
        " $temperature°",
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      SizedBox(
        height: 50,
        child: Image.network(
          "http:$imageUrl",
        ),
      ),
    ],
  );
}

Widget loadingIndicator({double size = 15}) {
  return SizedBox(
    width: size,
    height: size,
    child: CircularProgressIndicator(
      backgroundColor: HexColor("#002B5B"),
      color: HexColor("#57C5B6"),
    ),
  );
}

SizedBox buildBottomSheet(
    {required String city, required int index, required String day}) {
  return SizedBox(
    height: 300,
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
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder<WeatherData>(
              future: WeatherService().fetchWeatherData(city, index),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: loadingIndicator(size: 45));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No data found');
                } else {
                  final weather = snapshot.data!;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          day,
                          style: h2(),
                        ),

                        //min avg max
                        Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GetX<TempretureController>(builder: (context) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.sunny, color: Colors.yellow),
                                Text(
                                  tempretureController.isCelisuis.value
                                      ? "${"min".tr}: ${weather.day.minTempC.toInt()}"
                                      : "${"min".tr}: ${weather.day.minTempF.toInt()}",
                                ),
                                Text(
                                  tempretureController.isCelisuis.value
                                      ? "${"avg".tr}: ${weather.day.avgTempC.toInt()}"
                                      : "${"avg".tr}: ${weather.day.avgTempF.toInt()}",
                                ),
                                Text(
                                  tempretureController.isCelisuis.value
                                      ? "${"max".tr}: ${weather.day.maxTempC.toInt()}"
                                      : "${"max".tr}: ${weather.day.maxTempF.toInt()}",
                                ),
                              ],
                            );
                          }),
                        ),
                        //rain
                        Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.water_drop),
                              Text("${"wir".tr}"
                                  ": ${weather.day.dailyWillItRain.toInt() == 0 ? "no".tr : "yes".tr}"),
                              Text("${"cor".tr}"
                                  ": ${weather.day.dailyChanceOfRain}"),
                            ],
                          ),
                        ),
                        //snow
                        Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.cloudy_snowing),
                              Text("${"wis".tr}"
                                  ": ${weather.day.dailyWillItSnow.toInt() == 0 ? "no".tr : "yes".tr}"),
                              Text("${"con".tr}"
                                  ": ${weather.day.dailyChanceOfSnow}"),
                            ],
                          ),
                        ),
                        buildTempTime(city, index),
                      ],
                    ),
                  );
                }
              }),
        ),
      ],
    ),
  );
}

backgroundColor() {
  return Container(
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
  );
}
