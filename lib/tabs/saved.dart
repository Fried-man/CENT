import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../views/variant-view.dart';

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
  final Function updateParent;
  const Saved({Key? key, required this.updateParent}) : super(key: key);

  @override
  State<Saved> createState() => _Saved();
}

class _Saved extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return Container();

          List<Map<String, dynamic>> users = [];



          for (String id in snapshot.data["saved"]) {
            int currLength = users.length;

            if (currLength == users.length) {
              Map<String, dynamic> curr = {"accession" : id};
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

          return VariantView(
            title: "My Saved Variants",
            updateParent: widget.updateParent,
            getData: sendUsers(users),
          );
        },
      )
    );
  }
}

Future<Map<String, dynamic>> sendUsers (List<Map<String, dynamic>> input) async {
  return {"accessions" : input};
}