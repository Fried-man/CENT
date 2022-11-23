import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

import '../home.dart';

class VariantCard extends StatefulWidget {
  final Map variant;

  const VariantCard(
      {Key? key, required this.variant})
      : super(key: key);

  @override
  State<VariantCard> createState() => _VariantCard();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return variant["accession"];
  }
}

class _VariantCard extends State<VariantCard> {
  late String saveStatus; // TODO: fix remove from saved box going to add when moving

  @override
  void initState() {
    super.initState();
    saveStatus = "Add to Saved";
  }

  Future<Map<String, dynamic>> getVariants (String accession) async {
    var headers = {
      'Content-Type': 'text/plain'
    };
    var request = http.Request('POST', Uri.parse('https://genome2133functions.azurewebsites.net/api/GetDataFromAccession?code=1q32fFCX4A7_IrbXC-l-q1aboyDf3Q77hgeJO2lV2L6kAzFuD_mgTg=='));
    request.body = '''{\n    "accession": "MN985325.1"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(await response.stream.bytesToString()));
    }
    return {"error" : response.reasonPhrase};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: FutureBuilder<Map<String, dynamic>>(
        future: getVariants(widget.variant["accession"]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          if (snapshot.data!.containsKey("error")) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(snapshot.data!["error"])),
            );
          }
          
          return ListView(
            children: [
              for (String key in snapshot.data!.keys)
                Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    key + ": " + snapshot.data![key].toString(),
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () => launchUrl(Uri.parse(
                      'https://www.ncbi.nlm.nih.gov/nuccore/' + widget.variant["accession"])),
                  child: const Text(
                    "Open in NCBI",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              const Spacer(),
              if (FirebaseAuth.instance.currentUser == null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/login')
                          .then((value) => setState(() {}));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Login to Save",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 100,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              if (FirebaseAuth.instance.currentUser != null)
                StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: (){
                          print("loading saved...");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            saveStatus,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width / 100,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }

                  saveStatus = (snapshot.data!["saved"] as List).contains(widget.variant["accession"]) ? "Remove from Saved" : "Add to Saved";
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: (){
                        DocumentReference userDoc = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
                        if ((snapshot.data!["saved"] as List).contains(widget.variant["accession"])) {
                          userDoc.update({'saved' : FieldValue.arrayRemove([widget.variant["accession"]])});
                        }else {
                          userDoc.update({'saved' : FieldValue.arrayUnion([widget.variant["accession"]])});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          saveStatus,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 100,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ],
          );
        }
      ),
    );
  }
}