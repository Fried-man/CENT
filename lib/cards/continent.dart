import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genome_2133/cards/country.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../home.dart';
import "skeleton.dart";

Widget? cache;

class ContinentCard extends StatefulWidget {
  final String continent;
  final GoogleMapController mapController;
  final LatLng _initMapCenter = const LatLng(20, 0);
  final Function updateParent;

  const ContinentCard(
      {Key? key,
      required this.continent,
      required this.mapController,
      required this.updateParent})
      : super(key: key);

  @override
  State<ContinentCard> createState() => _ContinentCard();
}

class _ContinentCard extends State<ContinentCard> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> getContinent() async {
    var request = http.Request('GET',
        Uri.parse('https://restcountries.com/v3.1/region/' + widget.continent));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseDecoded = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(jsonDecode(responseDecoded));
    }
    return [
      {"error": response.reasonPhrase}
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  FutureBuilder(
                      future: getContinent(),
                      builder: (context, snapshot) {
                        return FutureBuilder(
                            future: rootBundle.loadString("assets/data.json"),
                            builder: (context, countrySnapshot) {
                              if (!snapshot.hasData || !countrySnapshot.hasData) {
                                if (cache != null) {
                                  return cache!;
                                }
                                return Expanded(child: Center(
                                  child: CircularProgressIndicator(
                                    color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),);
                              }

                              List countries = json.decode(countrySnapshot.data!
                                  .toString())["Countries"];
                              Map<String, List<String>> ordering = {};
                              for (Map<String, dynamic> country
                                  in (snapshot.data! as List)) {
                                for (Map<String, dynamic> storedCountry
                                    in countries) {
                                  if (country["cca3"] ==
                                      storedCountry["alpha3"]) {
                                    if (!ordering
                                        .containsKey(country["subregion"])) {
                                      ordering[country["subregion"]] = [];
                                    }
                                    ordering[country["subregion"]]!
                                        .add(storedCountry["country"]);
                                    break;
                                  }
                                }
                              }

                              List<Widget> output = [];
                              for (String region in ordering.keys) {
                                output.add(Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(region,
                                      style: const TextStyle(fontSize: 18)),
                                ));

                                ordering[region]!.sort();

                                for (String country in ordering[region]!) {
                                  output.add(Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      child: Text(
                                        country,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onTap: () {
                                        windows.add(SkeletonCard(
                                          updateParent: widget.updateParent,
                                          title: country,
                                          body: CountryCard(
                                            country: {"country": country},
                                            mapController: widget.mapController,
                                            updateParent: widget.updateParent,
                                          ),
                                        ));
                                        widget.updateParent();
                                      },
                                    ),
                                  ));
                                }
                              }
                              output.add(Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(),
                              ));

                              cache = Column(
                                children: output,
                              );
                              return cache!;
                            });
                      })
                ],
              ),
            )
          ],
        ));
  }
}
