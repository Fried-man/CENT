import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genome_2133/views/variant-view.dart';
import 'package:genome_2133/cards/variant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

import '../cards/country.dart';
import '../home.dart';
import '../cards/skeleton.dart';

class Region extends StatefulWidget {
  final Function updateParent;
  // is this necessary?
  final GoogleMapController mapController;

  const Region({Key? key, required this.updateParent, required this.mapController}) : super(key: key);

  @override
  State<Region> createState() => _Region();
}

class _Region extends State<Region> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Center(child: Text("Select Country")),
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 4,
          child: FutureBuilder(
              future: rootBundle.loadString("assets/data.json"),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) return Container();
                List countries = json.decode(snapshot.data!)["Countries"];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: TextField(
                          controller: search,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.search),
                            labelText: 'Search',
                          ),
                          onChanged: (text) {
                            setState(() {});
                          }),
                    ),
                    Flexible(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (int index = 0; index < countries.length; index++)
                            if (isValid(countries[index]["country"], search.text))
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              countries[index]["country"],
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          80,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right)
                                    ],
                                  ),
                                  onPressed: () {
                                    CountryCard selectedCountry = CountryCard(
                                      country: countries[index],
                                      mapController: widget.mapController,
                                      updateParent: widget.updateParent,
                                    );
                                    Navigator.pop(context, [
                                      SkeletonCard(
                                        updateParent: widget.updateParent,
                                        title: selectedCountry.toString(),
                                        body: selectedCountry,
                                      )
                                    ]);
                                  },
                                ),
                              )
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ));
  }

  bool isValid(String name, String search) {
    // Search algo
    search = search.toLowerCase();
    name = name.toLowerCase();
    for (var element in search.runes) {
      if (!name.contains(String.fromCharCode(element))) return false;
      if (String.fromCharCode(element).allMatches(search).length >
          String.fromCharCode(element).allMatches(name).length) return false;
    }
    return true;
  }
}
