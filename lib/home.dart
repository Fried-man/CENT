import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'faq.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
                              future: rootBundle.loadString("data.json"),
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
                          ),
                      ),
                    );
                  }),
                  headerButton(context, "Contact Us", () async {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Center(child: Text("Contact Us")),
                          content: SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Stack(
                              children: [
                                Form(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Your Email',
                                              prefixIcon: Icon(Icons.email)
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Your Message To The Team',
                                              prefixIcon: Icon(Icons.message)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ),
                          ),
                          actions: [
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.height / 20,
                                child: ElevatedButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width / 80,
                                          color: Colors.black
                                      ),
                                    ),
                                    onPressed: () {
                                      // your code
                                    }),
                              ),
                            )
                          ],
                        ));
                  }),
                  headerButton(context, "FAQ", () async {
                     showDialog(
                         context: context,
                         builder: (_) => AlertDialog(
                           title: const Center(child: Text("FAQ")),
                           content: SizedBox(
                             width: MediaQuery.of(context).size.width / 4,
                             height: MediaQuery.of(context).size.height / 2,
                             child: Center(child: faq(context))),
                         )
                     );
                  }),
                  headerButton(context, "My Saved", (){}),
                  headerButton(context, "Login", () {
                    Navigator.pushNamed(context, '/login');
                  })
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.hybrid,
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                initialCameraPosition: const CameraPosition(
                    bearing: 0,
                    target: LatLng(20, 0),
                    tilt: 0,
                    zoom: 3
                ),
                onMapCreated: (GoogleMapController controller) {
                  Completer().complete(controller);
                },
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