import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genome_2133/cards/variant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../home.dart';
import '../main.dart';
import '../views/variant-view.dart';
import 'continent.dart';
import "skeleton.dart";

class CountryCard extends StatefulWidget {
  final Map country;
  final LatLng _initMapCenter = const LatLng(20, 0);
  final Function updateParent;

  const CountryCard(
      {Key? key,
      required this.country,
      required this.updateParent})
      : super(key: key);

  @override
  State<CountryCard> createState() => _CountryCard();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return country["country"];
  }

  void centerMap() {
    if (isDesktop || isMapDisabled) return;

    mapController.animateCamera(CameraUpdate.newLatLngZoom(_initMapCenter, 3.2));
  }

  updateMap() async {
    if (isDesktop || isMapDisabled) return;

    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(
            country["latitude"],
            country["longitude"] -
                (-6.0 * country["zoom"] + 45.0)),
        country["zoom"].toDouble()));
  }
}

Map<String, Widget> variantsCache = {};
Map<String, Widget> statsCache = {};
List? jsonCountries;

class _CountryCard extends State<CountryCard> {
  _updateMap() async {
    if (isDesktop || isMapDisabled) return;

    // zoom offset is based on ex. "zoom 7 -> shift 3 over" & "zoom 3 -> shift 27 over"
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(
            widget.country["latitude"],
            widget.country["longitude"] -
                (-6.0 * widget.country["zoom"] + 45.0)),
        widget.country["zoom"].toDouble()));
  }

  @override
  void initState() {
    super.initState();
    _updateMap();
  }

  Future<Map<String, dynamic>> getVariantsRegion(
      {String region = "",
      String country = "",
      String state = "",
      int count = 12}) async {
    var headers = {'Content-Type': 'text/plain'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://genome2133functions.azurewebsites.net/api/GetAccessionsByRegion?code=e58u_e3ljQhe8gX3lElCZ79Ep3DOGcoiA54YzkamEEeDAzFuEobmzQ=='));
    request.body = '''{${region.isNotEmpty ? '''\n    "region": "$region",''' : ""}${country.isNotEmpty
            ? '''\n    "country": "$country",'''
            : ""}${state.isNotEmpty ? '''\n    "state": "$state",''' : ""}      \n    "count": ${count < 0 ? '''"all"''' : count.toString()}      \n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> map = Map<String, dynamic>.from(
          jsonDecode(await response.stream.bytesToString()));
      return map;
    }
    return {"error": response.reasonPhrase};
  }

  Future<Map<String, dynamic>> getCountryInfo(String cca3) async {
    var request = http.Request(
        'GET', Uri.parse('https://restcountries.com/v3.1/alpha/$cca3'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseDecoded = await response.stream.bytesToString();
      Map<String, dynamic> map =
          Map<String, dynamic>.from(jsonDecode(responseDecoded).first);
      return map;
    }
    return {"error": response.reasonPhrase};
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),

        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(
                      "Variants",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                      future:
                          getVariantsRegion(country: widget.country["country"]),
                      builder: (context, snapshot) {
                        if (variantsCache.containsKey(widget.country["country"])) {
                          return variantsCache[widget.country["country"]]!;
                        }
                        if (!snapshot.hasData) {
                          return SizedBox(
                            height: 120,
                            child: Center(
                              child: CircularProgressIndicator(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          );
                        }
                        if (snapshot.data!.containsKey("Something went wrong")) {
                          variantsCache[widget.country["country"]] = const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("No recorded variants."),
                          );
                          return variantsCache[widget.country["country"]]!;
                        }
                        if (snapshot.data!.containsKey("error")) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(snapshot.data!["error"])),
                          );
                        }

                        variantsCache[widget.country["country"]] = Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Wrap(
                                children: [
                                  for (Map variant
                                  in snapshot.data!["accessions"])
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            textStyle:
                                            const TextStyle(fontSize: 13)),
                                        onPressed: () {
                                          VariantCard selectedVariant =
                                          VariantCard(
                                            variant: variant,
                                            location: {"country" : widget.country},
                                            updateParent: widget.updateParent,
                                            controlKey: GlobalKey(),
                                          );
                                          addCard(SkeletonCard(
                                            controlKey: GlobalKey(),
                                            title: selectedVariant.toString(),
                                            body: selectedVariant,
                                            updateParent: widget.updateParent,
                                          ));
                                          widget.updateParent();
                                        },
                                        child: Text(
                                          variant["accession"]!,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                        return variantsCache[widget.country["country"]]!;
                      }),
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VariantView(
                                        country: widget.country,
                                        updateParent: widget.updateParent,
                                      )));
                        },
                        child: const Text(
                          "View More",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 12),
                    child: Text(
                      "Country Info",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                      future: getCountryInfo(widget.country["cca3"]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          if (statsCache.containsKey(widget.country["country"])) {
                            return statsCache[widget.country["country"]]!;
                          }
                          return SizedBox(
                            height: 175,
                            child: Center(
                              child: CircularProgressIndicator(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          );
                        }

                        List<TextSpan> formatContinents() {
                          List<TextSpan> output = [
                            TextSpan(
                                text: snapshot.data!["continents"].length == 1
                                    ? "Continent: "
                                    : "Continents: ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15))
                          ];

                          for (String continent
                              in snapshot.data!["continents"]) {
                            output.add(TextSpan(
                                text: continent ==
                                            snapshot.data!["continents"].last &&
                                        snapshot.data!["continents"].length > 1
                                    ? "and "
                                    : ""));
                            output.add(TextSpan(
                                text: continent,
                                style: const TextStyle(
                                  color:
                                      Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 15
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    addCard(SkeletonCard(
                                      controlKey: GlobalKey(),
                                      updateParent: widget.updateParent,
                                      title: continent,
                                      body: ContinentCard(
                                        continent: continent,
                                        updateParent: widget.updateParent,
                                      ),
                                    ));
                                    widget.updateParent();
                                  }));
                            output.add(TextSpan(
                                text: continent ==
                                        snapshot.data!["continents"].last
                                    ? ""
                                    : snapshot.data!["continents"].length != 2
                                        ? ", "
                                        : " "));
                          }

                          return output;
                        }

                        statsCache[widget.country["country"]] = Column(
                          children: [
                            // unMember
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: formatContinents(),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FutureBuilder(
                                  future:
                                  rootBundle.loadString("assets/data.json"),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> countriesSnapshot) {
                                    if (!countriesSnapshot.hasData && jsonCountries == null) {
                                      return Container();
                                    }

                                    if (countriesSnapshot.hasData && jsonCountries == null) {
                                      jsonCountries = json.decode(
                                          countriesSnapshot.data!)["Countries"];
                                    }

                                    String convertCountry(String cca3) {
                                      for (Map<String, dynamic> country
                                      in jsonCountries!) {
                                        if (cca3 == country["cca3"]) {
                                          return country["country"];
                                        }
                                      }
                                      return "";
                                    }

                                    Map<String, dynamic> getCountry (String name) {
                                      for (Map<String, dynamic> country
                                      in jsonCountries!) {
                                        if (name == country["country"]) {
                                          return country;
                                        }
                                      }
                                      return {};
                                    }

                                    List<String> countries = [];
                                    if (snapshot.data!.containsKey("borders")) {
                                      for (String country
                                      in snapshot.data!["borders"]) {
                                        String output = convertCountry(country);
                                        if (output.isNotEmpty) {
                                          countries.add(output);
                                        }
                                      }
                                    }
                                    List<TextSpan> countryFormat() {
                                      List<TextSpan> output = [
                                        TextSpan(
                                            text: snapshot.data!.containsKey(
                                                "borders") &&
                                                countries.length == 1
                                                ? "Neighbor: "
                                                : "Neighbors: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        if (!snapshot.data!
                                            .containsKey("borders") ||
                                            countries.isEmpty)
                                          const TextSpan(text: "None"),
                                      ];
                                      for (String country in countries) {
                                        output.add(TextSpan(
                                            text: country == countries.last &&
                                                countries.length > 1
                                                ? "and "
                                                : ""));
                                        output.add(TextSpan(
                                            text: country,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                              fontSize: 15
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                windows.add(SkeletonCard(
                                                  controlKey: GlobalKey(),
                                                  updateParent:
                                                  widget.updateParent,
                                                  title: country,
                                                  body: CountryCard(
                                                    country: getCountry(country),
                                                    updateParent:
                                                    widget.updateParent,
                                                  ),
                                                ));
                                                widget.updateParent();
                                              }));
                                        output.add(TextSpan(
                                            text: country == countries.last
                                                ? ""
                                                : countries.length != 2
                                                ? ", "
                                                : " "));
                                      }

                                      return output;
                                    }

                                    return RichText(
                                      text: TextSpan(
                                        style:
                                        DefaultTextStyle.of(context).style,
                                        children: countryFormat(),
                                      ),
                                    );
                                  }),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                        snapshot.data!["capital"].length ==
                                            1
                                            ? "Capital: "
                                            : "Capitals: ",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    for (String capital
                                    in snapshot.data!["capital"])
                                      TextSpan(
                                          text: (capital ==
                                              snapshot
                                                  .data!["capital"]
                                                  .last &&
                                              snapshot.data!["capital"]
                                                  .length >
                                                  1
                                              ? "and "
                                              : "") +
                                              capital +
                                              (capital ==
                                                  snapshot
                                                      .data!["capital"].last
                                                  ? ""
                                                  : snapshot.data!["capital"]
                                                  .length !=
                                                  2
                                                  ? ", "
                                                  : " ")),
                                  ],
                                ),
                              ),
                            ),
                            for (String key in {"area", "population"})
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${key.toTitleCase()}: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: (snapshot.data![key] < pow(10, 6) ?
                                          snapshot.data![key] : snapshot.data![key] < pow(10, 9) ?
                                          (snapshot.data![key] / pow(10, 6)).toStringAsFixed(2) :
                                          (snapshot.data![key] / pow(10, 9)).toStringAsFixed(2))
                                              .toString()
                                              .replaceAllMapped(
                                              RegExp(
                                                  r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                  (Match m) => '${m[1]},')),
                                      if (snapshot.data![key] >= pow(10, 6))
                                        TextSpan(text: snapshot.data![key] < pow(10, 9) ? " Million" : " Billion"),
                                    ],
                                  ),
                                ),
                              ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: "Population Density: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    TextSpan(
                                        text: (snapshot.data!["population"] /
                                            snapshot.data!["area"])
                                            .toStringAsFixed(2)
                                            .replaceAllMapped(
                                            RegExp(
                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (Match m) => '${m[1]},') + " per square km"),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: "United Nations: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    TextSpan(
                                        text: snapshot.data!["unMember"]
                                            ? "Member"
                                            : "Non-Member"),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: snapshot.data!["languages"].values
                                            .length ==
                                            1
                                            ? "Language: "
                                            : "Languages: ",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    for (String language
                                    in snapshot.data!["languages"].values)
                                      TextSpan(
                                          text: (language ==
                                              snapshot
                                                  .data![
                                              "languages"]
                                                  .values
                                                  .last &&
                                              snapshot
                                                  .data![
                                              "languages"]
                                                  .values
                                                  .length >
                                                  1
                                              ? "and "
                                              : "") +
                                              language +
                                              (language ==
                                                  snapshot
                                                      .data!["languages"]
                                                      .values
                                                      .last
                                                  ? ""
                                                  : snapshot.data!["languages"]
                                                  .values.length !=
                                                  2
                                                  ? ", "
                                                  : " ")),
                                  ],
                                ),
                              ),
                            ),
                            for (String key in {
                              "landlocked",
                              "independent",
                              "flag"
                            })
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${key.toTitleCase()}: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: snapshot.data![key]
                                              .toString()
                                              .toTitleCase()),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                        return statsCache[widget.country["country"]]!;
                      }),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 12),
                    child: Text(
                      "Future Variants",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12, right: 3),
                    child: Text(
                      "This section is meant to display the result of our "
                          "prediction algorithms' efforts to anticipate future "
                          "COVID-19 strains from the selected nation",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 18),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: null,
                          child: Text("Predict",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black))),
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("     ",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}
