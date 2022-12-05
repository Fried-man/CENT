import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:genome_2133/cards/skeleton.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home.dart';
import '../main.dart';
import 'country.dart';

class VariantCard extends StatefulWidget {
  final Map variant;
  final Map location;
  final LatLng _initMapCenter = const LatLng(20, 0);
  final Function updateParent;
  final GlobalKey<_VariantCard> controlKey;

  const VariantCard({required this.variant, this.location = const {}, required this.updateParent, required this.controlKey}) : super(key: controlKey);

  @override
  State<VariantCard> createState() => _VariantCard();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return variant["accession"];
  }
}

Map<String, Widget> cache = {};
Widget? saveButton;

class _VariantCard extends State<VariantCard> {
  late String
      saveStatus; // TODO: fix remove from saved box going to add when moving

  @override
  void initState() {
    super.initState();
    saveStatus = "Add to Saved";
  }

  void updateState() {
    setState(() {});
  }

  Future<Map<String, dynamic>> getVariants(String accession) async {
    var headers = {'Content-Type': 'text/plain'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://genome2133functions.azurewebsites.net/api/GetDataFromAccession?code=1q32fFCX4A7_IrbXC-l-q1aboyDf3Q77hgeJO2lV2L6kAzFuD_mgTg=='));
    request.body = '''{\n    "accession": "$accession"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
          jsonDecode(await response.stream.bytesToString()));
    }
    return {"error": response.reasonPhrase};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                      future: getVariants(widget.variant["accession"]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          if (cache.containsKey(widget.variant["accession"])) {
                            return cache[widget.variant["accession"]]!;
                          }
                          return Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color:
                                    dict[theme].scaffoldBackgroundColor,
                              ),
                            ),
                          );
                        }
                        if (snapshot.data!.containsKey("error")) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(snapshot.data!["error"], style: TextStyle(color: dict[theme].primaryColor))),
                          );
                        }
                        cache[widget.variant["accession"]] = Column(
                          children: [
                            for (String key in snapshot.data!.keys)
                              if (key != "Accession")
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "$key: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, color: dict[theme].primaryColor)),
                                        if (snapshot.data![key] == "GenBank")
                                          TextSpan(
                                            text: snapshot.data![key],
                                            style: TextStyle(
                                              color: dict[theme]
                                                  .highlightColor,
                                              decoration:
                                              TextDecoration.underline,
                                            ), // decoration: TextDecoration.underline
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launchUrl(Uri.parse(
                                                    "https://www.ncbi.nlm.nih.gov/genbank/"));
                                              },
                                          ),
                                        if (snapshot.data![key] != "GenBank")
                                          TextSpan(
                                              text: (key.contains("Date")
                                                  ? DateFormat("MMMM d, yyyy")
                                                  .format(DateTime.parse(
                                                  snapshot.data![key]
                                                      .toString()))
                                                  : snapshot.data![key] != null &&
                                                  double.tryParse(snapshot.data![key].toString()) !=
                                                      null
                                                  ? snapshot.data![key]
                                                  .toString()
                                                  .replaceAllMapped(
                                                  RegExp(
                                                      r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                      (Match m) =>
                                                  '${m[1]},')
                                                  : key.contains(
                                                  "Completeness")
                                                  ? snapshot.data![key]
                                                  .toString()
                                                  .toUpperCase()
                                                  : snapshot.data![key]
                                                  .toString()),
                                          style: TextStyle(color: dict[theme].primaryColor)),
                                      ],
                                    ),
                                  ),
                                ),
                            if (widget.location.containsKey("country"))
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Country: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: dict[theme].primaryColor)),
                                      TextSpan(
                                        text: widget.location["country"]["country"],
                                        style: TextStyle(
                                          color: dict[theme]
                                              .highlightColor,
                                          decoration:
                                          TextDecoration.underline,
                                        ), // decoration: TextDecoration.underline
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            addCard(SkeletonCard(
                                              controlKey: GlobalKey(),
                                              updateParent: widget.updateParent,
                                              title: widget.location["country"]["country"],
                                              body: CountryCard(
                                                country: widget.location["country"],
                                                updateParent: widget.updateParent,
                                              ),
                                            ));
                                            widget.updateParent();
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                        return cache[widget.variant["accession"]]!;
                      }),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: ElevatedButton(
                            onPressed: () => launchUrl(Uri.parse(
                                'https://www.ncbi.nlm.nih.gov/nuccore/' +
                                    widget.variant["accession"])),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                              child: Text(
                                "Open in NCBI",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15, color: dict[theme].primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (FirebaseAuth.instance.currentUser == null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login')
                                    .then((value) => setState(() {}));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                                child: Text(
                                  "Login to Save",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 15, color: dict[theme].primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (FirebaseAuth.instance.currentUser != null)
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  if (saveButton != null) {
                                    return saveButton!;
                                  }
                                  return ElevatedButton(
                                    onPressed: () {
                                      print("loading saved...");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0, top: 8.0),
                                      child: Text(
                                        saveStatus,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 15, color: dict[theme].primaryColor),
                                      ),
                                    ),
                                  );
                                }
                                
                                Map variant = {
                                  "accession" : widget.variant["accession"],
                                  "continent" : widget.variant["region"],
                                  "country" : widget.variant["location"],
                                };

                                bool isFound = false;
                                for (Map savedVarient in snapshot.data!["saved"]) {
                                  if (savedVarient["accession"] == variant["accession"]) {
                                    isFound = true;
                                    break;
                                  }
                                }

                                saveStatus = isFound
                                    ? "Unsave"
                                    : "Add to Saved";
                                saveButton = ElevatedButton(
                                  onPressed: () {
                                    DocumentReference userDoc =
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(FirebaseAuth
                                        .instance.currentUser!.uid);

                                    if (isFound) {
                                      userDoc.update({
                                        'saved': FieldValue.arrayRemove(
                                            [variant])
                                      });
                                    } else {
                                      userDoc.update({
                                        'saved': FieldValue.arrayUnion(
                                            [variant])
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, top: 8.0),
                                    child: Text(
                                      saveStatus,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 15, color: dict[theme].primaryColor),
                                    ),
                                  ),
                                );
                                return saveButton!;
                              }),
                        ))
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
