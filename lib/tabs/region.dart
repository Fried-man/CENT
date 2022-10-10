import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genome_2133/views/variant-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home.dart';

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
                          }),
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
                                    Navigator.pop(context, [
                                      RegionCard(
                                        country: countries[index],
                                        updateParent: widget.updateParent,
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

class RegionCard extends StatefulWidget {
  final String country;
  final Function updateParent;

  const RegionCard(
      {Key? key, required this.country, required this.updateParent})
      : super(key: key);

  @override
  State<RegionCard> createState() => _RegionCard();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return country;
  }

  Offset getPosition() => const Offset(0, 0);

  void updatePosition(Offset newPosition) {}
}

class _RegionCard extends State<RegionCard> {
  bool isClosed = false;
  late int fakeCount;

  Offset position = Offset(
      Random().nextDouble() *
          ((window.physicalSize / window.devicePixelRatio).width -
              (window.physicalSize / window.devicePixelRatio).width / 3),
      100 +
          Random().nextDouble() *
              ((window.physicalSize / window.devicePixelRatio).height -
                  (window.physicalSize / window.devicePixelRatio).height / 2 -
                  100));

  getPosition() => position;

  void updatePosition(Offset newPosition) =>
      setState(() => position = newPosition);

  @override
  void initState() {
    fakeCount = Random().nextInt(30) + 12;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isClosed) return Container();

    void riseStack() {
      // Change stack function
      if (widget == windows.last) return;

      // TODO: fix position swap bug
      /*windows.remove(widget);
      windows.add(widget);

      widget.updateParent();*/
    }

    Widget content = SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 3,
      child: GestureDetector(
        onTap: () {
          riseStack();
        },
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
                        width: MediaQuery.of(context).size.height / 3.5,
                        child: AutoSizeText(
                          widget.country + " Details",
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 40),
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
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Current Variants",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Align(
                              alignment: Alignment.center,
                              child: Wrap(
                                children: [
                                  for (int i = 0; i < fakeCount; i++)
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            textStyle:
                                                const TextStyle(fontSize: 13)),
                                        onPressed: () => launchUrl(Uri.parse(
                                            'https://www.ncbi.nlm.nih.gov/nuccore/OP365008')),
                                        child: const Text(
                                          "OM995898",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 18),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VariantView(
                                          country: widget.country))),
                              child: const Text(
                                "Further Info",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Report",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Image.asset(
                          "assets/images/fake_report.png",
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 18),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => debugPrint('pressedTextButton:'),
                              child: const Text(
                                "Further Info",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
        ),
      ),
    );

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
          maxSimultaneousDrags: 1,
          feedback: Material(type: MaterialType.transparency, child: content),
          childWhenDragging: Container(),
          onDragEnd: (details) {
            updatePosition(details.offset);
            riseStack();
          },
          child: content),
    );
  }
}
