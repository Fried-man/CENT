import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
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
      child: ListView(
        shrinkWrap: true,
        primary: false,
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
        ],
      ),
    );
  }
}