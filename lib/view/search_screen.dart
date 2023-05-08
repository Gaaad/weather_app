import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weather_app/controller/search_controller.dart';
import 'package:weather_app/model/reusable_components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  TextEditingController searchController = TextEditingController();

  SearchController controller = Get.put(SearchController());

  List<String> cities = [
    'Tokyo'.tr,
    'New York'.tr,
    'London'.tr,
    'Paris'.tr,
    'Beijing'.tr,
    'Shanghai'.tr,
    'Hong Kong'.tr,
    'Moscow'.tr,
    'Dubai'.tr,
    'Singapore'.tr,
    'Sydney'.tr,
    'Los Angeles'.tr,
    'Toronto'.tr,
    'San Francisco'.tr,
    'Seoul'.tr,
    'Berlin'.tr,
    'Madrid'.tr,
    'Rome'.tr,
    'Rio de Janeiro'.tr,
    'Istanbul'.tr,
    'Cairo'.tr,
    'Alexandria'.tr,
    'Giza'.tr,
    'Shubra El-Kheima'.tr,
    'Port Said'.tr,
    'Suez'.tr,
    'Luxor'.tr,
    'Mansoura'.tr,
    'Tanta'.tr,
    'Assiut'.tr,
    'Ismailia'.tr,
    'Faiyum'.tr,
    'Zagazig'.tr,
    'Aswan'.tr,
    'Damietta'.tr,
    'Minya'.tr,
    'Beni Suef'.tr,
    'Qena'.tr,
    'Sohag'.tr,
    'Hurghada'.tr
  ];

  List<String> _getFilteredCities(String query) {
    return cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase().tr))
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
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 650,
              child: GetX<SearchController>(
                builder: (context) {
                  return controller.city.value.isEmpty
                      ? Center(child: Text("npy".tr))
                      : buildSelectedLocationWeather(
                          city: searchController.text);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Container(
        margin: const EdgeInsets.symmetric(vertical: 100),
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: searchController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'search'.tr,
              suffixIcon: const Icon(Icons.search),
            ),
          ),
          suggestionsCallback: (query) => _getFilteredCities(query),
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.toString()),
            );
          },
          onSuggestionSelected: (suggestion) {
            searchController.text = suggestion;
            controller.city.value = suggestion;
          },
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            color: Colors.white.withOpacity(0.1),
          ),
          onSaved: (newValue) {
            controller.city.value = newValue!;
          },
        ),
      ),
      backgroundColor: HexColor("002B5B"),
      elevation: 0,
      centerTitle: true,
    );
  }
}
