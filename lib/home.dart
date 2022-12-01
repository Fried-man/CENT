import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genome_2133/cards/variant.dart';
import 'package:genome_2133/tabs/contact.dart';
import 'package:genome_2133/tabs/region.dart';
import 'package:genome_2133/tabs/settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cards/skeleton.dart';
import 'main.dart';
import 'tabs/faq.dart';

late List<SkeletonCard> windows;
late GoogleMapController mapController;
bool isMapDisabled = false;

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
          Center(child: Image.asset("assets/images/banner.png")),
          if (!isDesktop && !isMapDisabled)
            GoogleMap(
              mapType: MapType.hybrid,
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
                  headerButton(context, "Select Country", () async {
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
                  if (user == null)
                    headerButton(context, "Contact Us", () {
                      showDialog(
                          context: context, builder: (_) => contact(context));
                    }),
                  if (user != null)
                    headerButton(context, "My Saved", () {
                      Navigator.pushNamed(context, '/saved');
                    }),
                  headerButton(context, user == null ? "Login" : "Settings",
                          () async {
                        if (user == null) {
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
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
                fontSize: max(MediaQuery.of(context).size.width / 50, 16),
                color: Colors.black),
          ),
        ),
      ),
    ),
  );
}
