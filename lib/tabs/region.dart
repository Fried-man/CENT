import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cards/country.dart';
import '../cards/skeleton.dart';
import '../main.dart';

class Region extends StatefulWidget {
  final Function updateParent;

  const Region({Key? key, required this.updateParent}) : super(key: key);

  @override
  State<Region> createState() => _Region();
}

class _Region extends State<Region> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();

    return AlertDialog(
        title: Center(child: Text("Select Country", style:TextStyle(color: dict[theme].primaryColor))),
        content: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 4,
          child: FutureBuilder(
              future: rootBundle.loadString("assets/data.json"),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) return Container();
                List countries = json.decode(snapshot.data!)["Countries"];
                Map temp = countries.first;
                countries.remove(temp); // USA baby
                countries.sort((a,b) => a["country"].compareTo(b["country"]));
                countries.insert(0, temp);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: TextField(
                          style: TextStyle(color: dict[theme].primaryColor),
                          controller: search,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: BorderSide(color: dict[theme].primaryColor, width: 0.0),
                            ),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.search, color: dict[theme].primaryColor),
                            labelText: 'Search',
                            labelStyle: TextStyle(color: dict[theme].primaryColor),
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
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          80,
                                                  color: dict[theme].primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right,
                                      color: dict[theme].primaryColor,)
                                    ],
                                  ),
                                  onPressed: () {
                                    CountryCard selectedCountry = CountryCard(
                                      country: countries[index],
                                      updateParent: widget.updateParent,
                                      controlKey: GlobalKey(),
                                    );
                                    Navigator.pop(context, [
                                      SkeletonCard(
                                        controlKey: GlobalKey(),
                                        updateParent: widget.updateParent,
                                        title: selectedCountry.toString(),
                                        body: selectedCountry,
                                      ),
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
