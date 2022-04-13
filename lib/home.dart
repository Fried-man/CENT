import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //.then((value) => print(j));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerButton(context, "Select Region(s)", () async {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Center(child: Text("Select Region(s)")),
                        content:
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 4,
                            child: FutureBuilder(
                              future: DefaultAssetBundle.of(context).loadString("data.json"),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (!snapshot.hasData) return const Text("");
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
                                            return MaterialButton(
                                              color: Colors.white,
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
                                            );
                                          }
                                      ),
                                    ),
                                  ],
                                );
                                return Text(json.decode(snapshot.data!)["Countries"].toString());
                              }
                            ),
                          ),
                      ),
                    );
                  }),
                  headerButton(context, "Contact Us", (){}),
                  headerButton(context, "FAQ", (){}),
                  headerButton(context, "My Saved", (){}),
                  headerButton(context, "Login", (){})
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                  "assets/images/map.jpg",
                  fit: BoxFit.cover
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget headerButton (var context, String text, void Function() action) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: action,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 50,
              color: Colors.black
            ),
          ),
        ),
      ),
    ),
  );
}