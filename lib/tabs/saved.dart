import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../views/variant-view.dart';

int? sortColumnIndex;
bool isAscending = false;

class Saved extends StatefulWidget {
  final Function updateParent;
  const Saved({Key? key, required this.updateParent}) : super(key: key);

  @override
  State<Saved> createState() => _Saved();
}

class _Saved extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VariantView(
        title: "My Saved Variants",
        updateParent: widget.updateParent,
        getData: sendUsers(),
      )
    );
  }
}

Future<Map<String, dynamic>> sendUsers () async {
  Map<String, dynamic> data = (await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get()).data()!;

  List<String> accessions = [];
  for (Map<String, dynamic> variant in List.from(data["saved"])) {
    accessions.add(variant["accession"]);
  }

  List<Map<String, dynamic>> output = [];
  for (Map<String, dynamic> variant in (await getVariants(input: accessions)).values) {
    Map<String, dynamic> firebaseVariant = List.from(data["saved"]).where((element) => element["accession"] == variant["Accession"]).first;
    for (String key in firebaseVariant.keys) {
      if (key != "accession") {
        variant[key] = firebaseVariant[key];
      }
    }


    variant.remove("Nucleotide Completeness");
    for (String key in {"generated", "pinned"}) {
      if (!variant.containsKey(key)) {
        variant[key] = false;
      }
    }
    output.add(variant);
  }
  return {"accessions" : output};
}

Future<Map<String, dynamic>> getVariants(
    {required List<String> input}) async {
  
  var headers = {
    'Content-Type': 'text/plain'
  };
  var request = http.Request('POST', Uri.parse('https://genome2133functions.azurewebsites.net/api/GetDataFromAccession?code=1q32fFCX4A7_IrbXC-l-q1aboyDf3Q77hgeJO2lV2L6kAzFuD_mgTg=='));
  request.body = '''{\n    "accession" : ${jsonEncode(input)}\n}''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String feedback = await response.stream.bytesToString();
    if (feedback == "Failed") {
      return {"error": response.reasonPhrase};
    }

    Map<String, dynamic> map = Map<String, dynamic>.from(jsonDecode(feedback));
    return map;
  }
  return {"error": response.reasonPhrase};
}