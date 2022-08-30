import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';

class Region extends StatefulWidget {
  const Region({Key? key}) : super(key: key);
  @override
  State<Region> createState() => _Region();
}

class _Region extends State<Region> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Center(child: Text("Select Region")),
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
                          }
                      ),
                    ),
                    Flexible(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (int index = 0; index < countries.length; index++)
                            if (isValid(countries[index], search.text))
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
                                              countries[index],
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width / 80,
                                                  color: Colors.black
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right)
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, [RegionCard(country: countries[index])]);
                                  },
                                ),
                              )
                        ],
                      ),
                    ),
                  ],
                );
              }
          ),
        )
    );
  }

  bool isValid(String name, String search) { // Search algo
    search = search.toLowerCase();
    name = name.toLowerCase();
    for (var element in search.runes) {
      if (!name.contains(String.fromCharCode(element))) return false;
      if (String.fromCharCode(element).allMatches(search).length > String.fromCharCode(element).allMatches(name).length) return false;
    }
    return true;
  }
}

class RegionCard extends StatefulWidget {
  final String country;

  const RegionCard({Key? key, required this.country}) : super(key: key);

  @override
  State<RegionCard> createState() => _RegionCard();
}

class _RegionCard extends State<RegionCard> {
  bool isClosed = false;

  @override
  Widget build(BuildContext context) {
    if (isClosed) return Container();

    return Center(
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.height / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Container(
                  color: Colors.indigo,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height / 3.3,
                          child: AutoSizeText(
                            widget.country + " Details",
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onTap: () {
                            // TODO: add cleanup to home array
                            setState(() {
                              isClosed = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Current Variants",
                              style: TextStyle(
                                  fontSize: 30
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Wrap(
                              children: [
                                for (int i = 0; i < Random().nextInt(42) + 12; i++)
                                  const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(
                                      "OM995898",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 18),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "See More...",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Report",
                              style: TextStyle(
                                  fontSize: 30
                              ),
                            ),
                          ),
                          Image.asset(
                            "assets/images/fake_report.png",
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 18),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "See More...",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}