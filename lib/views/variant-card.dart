import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description: " + widget.variant["accession"],
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Region: " + widget.variant["geographical location"],
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Date Collected: " + widget.variant["date collected"].toString(),
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
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();

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
                      (snapshot.data!["saved"] as List).contains(widget.variant["accession"]) ? "Remove from Saved" : "Add to Saved",
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
      ),
    );
  }
}