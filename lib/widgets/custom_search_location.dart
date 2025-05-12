// ignore_for_file: deprecated_member_use

import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_maps_webservices/places.dart';

class CustomSearchLocation extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? fillColor;
  final FocusNode? focusNode;
  final String state;
  // final bool stateValidation;
  const CustomSearchLocation({
    super.key,
    required this.controller,
    required this.state,
    required this.hintText,
    this.fillColor,
    this.focusNode,
    // required this.stateValidation,
  });

  @override
  State<CustomSearchLocation> createState() => _CustomSearchLocationState();
}

class _CustomSearchLocationState extends State<CustomSearchLocation> {
  void _navigateToSearchPage() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchLocationPage(
                state: widget.state,
              )),
    );

    if (selectedLocation != null) {
      // widget.widget = selectedLocation;
      widget.controller?.text = selectedLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: true,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyle().hintText,
        fillColor: widget.fillColor ?? ColorConstants.white,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        // border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // color: redColor,
            // width: 2.0,
          ),
        ),

        errorStyle: TextStyle(
          color: Colors.red[900], // Change error text color
          fontSize: 13, // Adjust error text size if needed
        ),
      ),
      onTap: _navigateToSearchPage,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select address';
        }
        return null;
      },
    );
  }
}

class SearchLocationPage extends StatefulWidget {
  final String state;
  const SearchLocationPage({super.key, required this.state});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  String kGoogleApiKey = dotenv.env['API_KEY'] ?? '';
  // String kGoogleApiKey = 'AIzaSyA5TT3UUixs2V3IGu1t9wjXkkCRCn3n2hg';
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapsPlaces googlePlace;
  List<Prediction> predictions = [];

  @override
  void initState() {
    super.initState();
    googlePlace = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  }

  void _searchPlaces(String input) async {
    try {
      final result = await googlePlace.autocomplete(
        input,
        // components: [Component("country", "IN")],
      );

      if (result.predictions != []) {
        setState(() {
          predictions = result.predictions;
        });
      } else {
        setState(() {
          predictions = [];
        });
        debugPrint("No predictions found.");
      }
    } catch (error) {
      debugPrint("Error occurred while fetching places: $error");
      setState(() {
        predictions = [];
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      predictions = [];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorConstants.white,
        shadowColor: ColorConstants.darkGray.withOpacity(0.5),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
              hintText: "Search location",
              helperStyle: AppTextStyle().hintText,
              border: InputBorder.none
              // border: OutlineInputBorder(),
              ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              _searchPlaces(value);
            } else {
              setState(() {
                predictions = [];
              });
            }
          },
        ),
        actions: [
          IconButton(onPressed: _clearSearch, icon: const Icon(Icons.close))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final prediction = predictions[index];
                  return ListTile(
                    splashColor: ColorConstants.buttonColor,
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(prediction.description ?? ""),
                    onTap: () {
                      if (prediction.description?.contains(widget.state) ??
                          false) {
                        Navigator.pop(context, prediction.description);
                      } else {
                        // Show a validation message or feedback to the user if the location is not valid

                        Utils.toastSuccessMessage(
                            "Please select a location in ${widget.state}");
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
