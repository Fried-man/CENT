import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: rootBundle.loadString("assets/data.json"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) return Container();
          return recursiveList(json.decode(snapshot.data!)["FAQ"]);
        });
  }
}

AlertDialog faq(context) {
  return AlertDialog(
    title: const Center(child: Text("Frequently Asked Questions")),
    content: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 2,
        child: FAQ()),
  );
}

Widget recursiveList(content) {
  if (content is List) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: content.length,
      itemBuilder: (context, index) {
        if (content[index].containsKey("Question")) {
          return ExpansionTile(
            textColor: Colors.black,
            title: Text(content[index]["Question"]),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(content[index]["Answer"]),
              )
            ],
          );
        }
        return ExpansionTile(
          textColor: Colors.black,
          title: Text(content[index]["Title"]),
          children: [
            ListTile(subtitle: recursiveList(content[index]["Content"]))
          ],
        );
      },
    );
  }
  return ExpansionTile(
      textColor: Colors.black,
      title: Text(content["Question"]),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(content["Answer"]),
        )
      ]);
}
