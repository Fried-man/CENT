import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

List<String> headerLabel = [
  'accession',
  'geographical location',
  'date collected',
  'generated',
  'pinned'
];
int? sortColumnIndex;
bool isAscending = false;

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _Saved();
}

class _Saved extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SortablePage(),
    );
  }
}

class SortablePage extends StatefulWidget {
  const SortablePage({Key? key}) : super(key: key);

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: Column(
        children: [
          Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
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
                            "My Saved",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                //color: Theme.of(context).dialogBackgroundColor
                            ),
                          ),
                        )
                    )
                  ]
              )
          ),
          Stack(
            children: [
              Container(color: Theme.of(context).backgroundColor),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) return Container();

                  List<Map> users = [];



                  for (String id in snapshot.data["saved"]) {
                    int currLength = users.length;

                    if (currLength == users.length) {
                      Map curr = {"accession" : id};
                      for (String attribute in headerLabel) {
                        if (attribute != "accession") {
                          curr[attribute] = attribute != "generated" && attribute != "pinned" ? "no data" : false;
                        }
                      }
                      users.add(curr);
                    }
                  }


                  if (snapshot.data["saved"].isEmpty) {
                    return const Center(child: Text("No saved variants"));
                  }

                  return VariantTable(users: users);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  String get toTitle => split(" ").map((str) => str.capitalize()).join(" ");
}

class VariantTable extends StatefulWidget {
  final List<Map> users;
  const VariantTable({Key? key, required this.users}) : super(key: key);

  @override
  _VariantTable createState() => _VariantTable();
}

class _VariantTable extends State<VariantTable> {
  @override
  Widget build(BuildContext context) {
    List<Map> users = List<Map>.from(widget.users);

    List<DataCell> getCells(List<dynamic> cells) => cells
        .map((data) => DataCell(Align(
        alignment: Alignment.centerRight, child: Text(data.toString()))))
        .toList();

    int compareString(bool ascending, String value1, String value2) =>
        ascending ? value1.compareTo(value2) : value2.compareTo(value1);

    void onSort(int columnIndex, bool ascending) {
      users.sort((user1, user2) => compareString(
          ascending,
          user1[headerLabel[columnIndex]].toString(),
          user2[headerLabel[columnIndex]].toString()));

      setState(() {
        sortColumnIndex = columnIndex;
        isAscending = ascending;
      });
    }

    List<DataColumn> getColumns(List<String> columns) => columns
        .map((String column) => DataColumn(
      label: Expanded(
          child: Text(column.toTitle, textAlign: TextAlign.center)),
      onSort: onSort,
    ))
        .toList();

    List<DataRow> getRows(List users) => users.map((user) {
      List<DataCell> lister = getCells([
        user["accession"],
        user["geographical location"],
        user["date collected"],
        user["generated"] ? "Yes" : "Actual"
      ]);

      lister.add(DataCell(Align(
          alignment: Alignment.centerRight,
          child: user["pinned"]
              ? const Icon(
            Icons.push_pin,
            color: Color(0xff445756),
          )
              : const Icon(Icons.panorama_fish_eye,
              color: Color(0xffcccccc)))));
      return DataRow(cells: lister);
    }).toList();


    return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                sortAscending: isAscending,
                sortColumnIndex: sortColumnIndex,
                columns: getColumns(headerLabel),
                rows: getRows(users),
              ),
            ),
          ),
        ));
  }
}
