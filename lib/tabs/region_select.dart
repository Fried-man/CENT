import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AlertDialog region (context) {
  return AlertDialog(
      title: const Center(child: Text("Select Region(s)")),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 4,
        child: FutureBuilder(
            future: rootBundle.loadString("assets/data.json"),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) return Container();
              List countries = json.decode(snapshot.data!)["Countries"];
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                        labelText: 'Search',
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: countries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          countries[index],
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width / 80,
                                              color: Colors.black
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right)
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              );
            }
        ),
      )
  );
}