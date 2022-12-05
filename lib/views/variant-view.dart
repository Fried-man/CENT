import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genome_2133/cards/continent.dart';
import 'package:genome_2133/cards/variant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cards/country.dart';
import '../cards/skeleton.dart';
import '../home.dart';
import '../main.dart';

List selections = [];
late List countries;

class VariantView extends StatefulWidget {
  final String title;
  final Function updateParent;
  final Future<Map<String, dynamic>> Function() getData;

  const VariantView(
      {Key? key,
      required this.title,
      required this.updateParent,
      required this.getData
      })
      : super(key: key);

  @override
  State<VariantView> createState() => _VariantView();
}

class _VariantView extends State<VariantView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dict[theme].scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: dict[theme].dialogBackgroundColor,
                child: FutureBuilder(
                    future: rootBundle.loadString("assets/data.json"),
                    builder: (BuildContext context, AsyncSnapshot<String> countriesSnapshot) {
                      return FutureBuilder<Map<String, dynamic>>(
                          future: widget.getData(),
                          builder: (context, snapshot) {
                            Widget header = Container(
                                color: dict[theme].scaffoldBackgroundColor,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Icon(
                                                Icons.chevron_left,
                                                size: MediaQuery.of(context).size.width / 30,
                                                color: dict[theme].primaryColorLight,
                                              ),
                                            ),
                                          ),
                                          Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(20),
                                                child: Text(
                                                  widget.title,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: dict[theme].primaryColorLight
                                                  ),
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: IconButton(
                                              icon: Icon(Icons.content_copy, color: dict[theme].primaryColorLight),
                                              tooltip: "Copy selected variants to clipboard",
                                              onPressed: () {},
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(fontSize: 18),), //style
                                                onPressed: () {},
                                                child: Text('Copy All', style: TextStyle(color: dict[theme].primaryColor)))),
                                        Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(fontSize: 18),), //style
                                                onPressed: () => launchUrl(Uri.parse(
                                                    'https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome')),
                                                child: Text('Compare', style: TextStyle(color: dict[theme].primaryColor)))),
                                      ]),
                                    ]
                                )
                            );

                            if (!snapshot.hasData || !countriesSnapshot.hasData) {
                              return Column(
                                children: [
                                  header,
                                  Expanded(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color:
                                        dict[theme].scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            countries = json.decode(countriesSnapshot.data!)["Countries"];

                            List<Map<String, dynamic>> regionView =
                            List<Map<String, dynamic>>.from(snapshot.data!["accessions"]);
                            if (regionView.isEmpty) {
                              return Column(
                                children: [
                                  header,
                                  const Expanded(child: Center(child: Text("No Saved Variants"))),
                                ],
                              );
                            }

                            for (Map<String, dynamic> variant in regionView) {
                              variant["selected"] = false;
                            }

                            header = Container(
                                color: dict[theme].scaffoldBackgroundColor,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Icon(
                                                Icons.chevron_left,
                                                size: MediaQuery.of(context).size.width / 30,
                                                color: dict[theme].primaryColorLight,
                                              ),
                                            ),
                                          ),
                                          Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(20),
                                                child: Text(
                                                  widget.title,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: dict[theme].primaryColorLight
                                                  ),
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: IconButton(
                                              icon: Icon(Icons.content_copy, color: dict[theme].primaryColorLight),
                                              tooltip: "Copy selected variants to clipboard",
                                              onPressed: () async {
                                                if (!snapshot.hasData || !countriesSnapshot.hasData) return;

                                                await Clipboard.setData(ClipboardData(
                                                    text: selections
                                                        .toString()
                                                        .replaceAll("[", '')
                                                        .replaceAll("]", '')
                                                        .replaceAll(", ", "\n")))
                                                    .then((_) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                          content: Text(selections.isNotEmpty ? 'Copied selected variants to clipboard' : "No variants selected")));
                                                });
                                              },
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(fontSize: 18),), //style
                                                onPressed: () async {
                                                  if (!snapshot.hasData || !countriesSnapshot.hasData) return;

                                                  List<String> allVariants = [];
                                                  for (Map<String, dynamic> variant in regionView) {
                                                    allVariants.add(variant["accession"]);
                                                  }
                                                  await Clipboard.setData(ClipboardData(
                                                      text: allVariants
                                                          .toString()
                                                          .replaceAll("[", '')
                                                          .replaceAll("]", '')
                                                          .replaceAll(", ", "\n")))
                                                      .then((_) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                            content: Text('Copied all variants to clipboard')));
                                                  });
                                                },
                                                child: Text('Copy All', style: TextStyle(color: dict[theme].primaryColor)))),
                                        Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(fontSize: 18),), //style
                                                onPressed: () => launchUrl(Uri.parse(
                                                    'https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome')),
                                                child: Text('Compare', style: TextStyle(color: dict[theme].primaryColor)))),
                                      ]),
                                    ]
                                )
                            );

                            return Column(
                              children: [
                                header,
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child:SortablePage(
                                        items: regionView,
                                        updateParent: widget.updateParent),
                                  ),
                                ),
                              ],
                            );
                          }
                      );
                    }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SortablePage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function updateParent;

  const SortablePage(
      {Key? key,
      required this.items,
      required this.updateParent})
      : super(key: key);

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  late List<String> headerLabel;
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    headerLabel = List<String>.from(widget.items.first.keys);
    headerLabel.sort();
    headerLabel.remove("pinned");
    headerLabel.add("pinned");
    headerLabel.remove("accession");
    headerLabel.insert(0, "accession");
    sortColumnIndex = headerLabel.indexOf("pinned");
    widget.items.sort((a, b) => a["pinned"] && !b["pinned"] ? 0 : 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: dict[theme].dialogBackgroundColor,
          child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: buildDataTable(),
                ),
              )
          ),
        ),
      );

  Widget buildDataTable() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DataTable(
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(headerLabel),
        rows: getRows(widget.items),
        dataTextStyle: TextStyle(color: dict[theme].primaryColor),
        headingRowColor: MaterialStateColor.resolveWith((states) {return dict[theme].dialogBackgroundColor;},),
        dataRowColor: MaterialStateColor.resolveWith((states) {return dict[theme].dialogBackgroundColor;},),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Expanded(
                child: Text(
                  column.toTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dict[theme].primaryColor),
                )),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List items) => items.map((user) {
        List<DataCell> lister;

        List<dynamic> data = [];
        for (String key in headerLabel) {
          if (key != "accession" && key != "selected" && key != "pinned" && key != "continent" && key != "country") {
            data.add(user[key]);
          }
        }
        lister = getCells(data.toList());

        lister.insert(0, DataCell(
            Align(
                alignment: Alignment.centerRight,
                child: Text(user["accession"].toString(), style: TextStyle(color: dict[theme].primaryColor))), onTap: () {
          Navigator.pop(context);
          VariantCard selectedVariant = VariantCard(
            variant: user,
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
        }));

        if (headerLabel.contains("continent")) {
          lister.add(DataCell(
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(user["continent"].toString(), style: TextStyle(color: dict[theme].primaryColor))), onTap: () {
            Navigator.pop(context);
            ContinentCard selectedContinent = ContinentCard(
              continent: user["continent"],
              updateParent: widget.updateParent,
              controlKey: GlobalKey(),
            );
            addCard(SkeletonCard(
              controlKey: GlobalKey(),
              title: selectedContinent.toString(),
              body: selectedContinent,
              updateParent: widget.updateParent,
            ));
            widget.updateParent();
          }));
        }
        if (headerLabel.contains("country")) {
          lister.add(DataCell(
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(user["country"].toString(), style: TextStyle(color: dict[theme].primaryColor))), onTap: () {
            Navigator.pop(context);
            CountryCard selectedContinent = CountryCard(
              country: countries.where((element) => element["country"] == user["country"]).first,
              updateParent: widget.updateParent,
              controlKey: GlobalKey(),
            );
            addCard(SkeletonCard(
              controlKey: GlobalKey(),
              title: selectedContinent.toString(),
              body: selectedContinent,
              updateParent: widget.updateParent,
            ));
            widget.updateParent();
          }));
        }

        lister.add(DataCell(Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: user["selected"]
                ? Icon(Icons.done_sharp, color: dict[theme].primaryColor)
                : Icon(Icons.check_box_outline_blank, color: dict[theme].primaryColor),
            //color: const Color(0xff445756),
            onPressed: () {
              setState(() {
                user["selected"] = !user["selected"];
                if (user["selected"]) {
                  selections.add(user["accession"]);
                } else {
                  selections.remove(user["accession"]);
                }
              });
            },
          ),
        )));
        lister.add(DataCell(Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: user["pinned"]
                ? Icon(Icons.push_pin, color: dict[theme].primaryColor)
                : Icon(Icons.push_pin_outlined, color: dict[theme].primaryColor),
            //color: const Color(0xff445756),
            onPressed: () {
              setState(() {
                user["pinned"] = !user["pinned"];
                if (headerLabel.contains("Last Update Date")) {
                  List<Map<String, dynamic>> output = [];
                  for (Map<String, dynamic> variant in widget.items) {
                    output.add({
                      "accession" : variant["accession"],
                      "continent" : variant["continent"],
                      "country" : variant["country"],
                      "pinned" : variant["pinned"]
                    });
                  }

                  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"saved" : output});
                }
              });
            },
          ),
        )));

        return DataRow(cells: lister);
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(Align(
          alignment: Alignment.centerRight, child: Text(data.toString()))))
      .toList();

  void onSort(int columnIndex, bool ascending) {
    widget.items.sort((user1, user2) => compareString(
        ascending,
        user1[headerLabel[columnIndex]].toString(),
        user2[headerLabel[columnIndex]].toString()));

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

extension StringExtension on String {
  String capitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  String get toTitle => split(" ").map((str) => str.capitalize()).join(" ");
}
