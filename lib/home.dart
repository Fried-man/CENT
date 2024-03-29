import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genome_2133/cards/variant.dart';
import 'package:genome_2133/tabs/contact.dart';
import 'package:genome_2133/tabs/region.dart';
import 'package:genome_2133/tabs/saved.dart';
import 'package:genome_2133/tabs/settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cards/skeleton.dart';
import 'main.dart';
import 'tabs/faq.dart';

late List<SkeletonCard> windows;
late GoogleMapController mapController;

void addCard(SkeletonCard card) {
  for (SkeletonCard xCard in windows) {
    if (card.toString() == xCard.toString()) {
      xCard.controlKey.currentState!.updateActive();
      return;
    }
  }
  windows.add(card);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final LatLng _initMapCenter = const LatLng(20, 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (theme == "Dark Mode") {
      DefaultAssetBundle.of(context).loadString('assets/data.json').then((string) {
        mapController.setMapStyle(json.encode(json.decode(string)["Dark Mode"]));
    });
    }
  }

  @override
  void initState() {
    windows = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(context: context, builder: (_) => faq(context));
        },
        child: const Icon(Icons.question_mark),
      ),
      body: Stack(
        children: [
          Center(child: Image.asset("assets/images/desktop.png")),
          if (!isDesktop && !isMapDisabled)
            GoogleMap(
              mapType: theme == "Default" ? MapType.hybrid : MapType.none,
              zoomControlsEnabled: false,
              compassEnabled: false,
              scrollGesturesEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                  bearing: 0, target: _initMapCenter, tilt: 0, zoom: 3.2),
              onMapCreated: _onMapCreated,
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerButton(context, "Search", () async {
                    showDialog(
                      context: context,
                      builder: (_) => Region(updateParent: () {
                        setState(() {});
                      }),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          addCard(value[0]);
                        });
                      }
                    });
                  }),
                  if (FirebaseAuth.instance.currentUser == null)
                    headerButton(context, "Contact Us", () {
                      showDialog(
                          context: context, builder: (_) => contact(context));
                    }),
                  if (FirebaseAuth.instance.currentUser != null)
                    headerButton(context, "My Saved", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Saved(updateParent: () {
                                setState(() {});
                              }))
                      );
                    }),
                  headerButton(context, FirebaseAuth.instance.currentUser == null ? "Login" : "Settings",
                          () async {
                        if (FirebaseAuth.instance.currentUser == null) {
                          Navigator.pushNamed(context, '/login')
                              .whenComplete(() {
                            if (user != null) {
                              setState(() {
                                for (SkeletonCard card in windows) {
                                  if (card.body is VariantCard) {
                                    (card.body as VariantCard).controlKey.currentState!.updateState();
                                  }
                                }
                              });
                            }
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Settings())
                          ).whenComplete(() {
                            if (user == null) {
                              for (SkeletonCard card in windows) {
                                if (card.body is VariantCard) {
                                  (card.body as VariantCard).controlKey.currentState!.updateState();
                                }
                              }
                            }
                            setState(() {});
                          });
                        }
                      })
                ],
              ),
            ),
          ),
          for (Widget pane in windows) pane,
        ],
      ),
    );
  }
}

Widget headerButton(var context, String text, void Function() action) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: action,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            text,
            maxLines: 1,
            style: TextStyle(
                fontSize: max(MediaQuery.of(context).size.width / 50, 18),
                color: dict[theme].primaryColor),//
          ),
        ),
      ),
    ),
  );
}