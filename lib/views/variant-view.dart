import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genome_2133/cards/variant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../cards/skeleton.dart';
import '../home.dart';

List selections = [];

class VariantView extends StatefulWidget {
  final String title;
  final Function updateParent;
  final Future<Map<String, dynamic>> getData;

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
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: Column(
        children: [
          Container(
              color: Theme.of(context).scaffoldBackgroundColor,
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
                              //color: Theme.of(context).dialogBackgroundColor,
                            ),
                          ),
                        ),
                        Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                widget.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 30,
                                    //color: Theme.of(context).dialogBackgroundColor
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
                            icon: const Icon(Icons.content_copy),
                            tooltip: "Copy selected variants to clipboard",
                            //color: Theme.of(context).dialogBackgroundColor,
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: selections
                                      .toString()
                                      .replaceAll("[", '')
                                      .replaceAll("]", '')
                                      .replaceAll(", ", "\n")))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Copied variants to clipboard')));
                              });
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: ElevatedButton(
                              style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 18),
                                  backgroundColor: Theme.of(context).dialogBackgroundColor), //style
                              onPressed: () => launchUrl(Uri.parse(
                                  'https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome')),
                              child: const Text('Compare')))
                    ]),
                  ]
              )
          ),
          Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                  future: widget.getData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color:
                          Theme.of(context).scaffoldBackgroundColor,
                        ),
                      );
                    }

                    List<Map<String, dynamic>> regionView =
                    List<Map<String, dynamic>>.from(snapshot.data!["accessions"]);
                    for (Map<String, dynamic> variant in regionView) {
                      variant["selected"] = false;
                      variant["pinned"] = false;
                    }

                    return SortablePage(
                        items: regionView,
                        updateParent: widget.updateParent);
                  }
              ),
          )
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
    print(headerLabel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: Theme.of(context).backgroundColor,
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
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Expanded(
                child: Text(column.toTitle, textAlign: TextAlign.center)),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List items) => items.map((user) {
        List<DataCell> lister;

        List<dynamic> data = [];
        for (String key in headerLabel) {
          if (key != "accession" && key != "selected" && key != "pinned") {
            data.add(user[key]);
          }
        }
        lister = getCells(data.toList());

        lister.insert(0, DataCell(
            Align(
                alignment: Alignment.centerRight,
                child: Text(user["accession"].toString())), onTap: () {
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

        lister.add(DataCell(Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: user["selected"]
                ? const Icon(Icons.done_sharp)
                : const Icon(Icons.check_box_outline_blank),
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
                ? const Icon(Icons.push_pin)
                : const Icon(Icons.push_pin_outlined),
            //color: const Color(0xff445756),
            onPressed: () {
              setState(() {
                user["pinned"] = !user["pinned"];
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
