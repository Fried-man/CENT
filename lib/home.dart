import 'dart:async';
import 'package:flutter/material.dart';
import 'package:genome_2133/tabs/contact.dart';
import 'package:genome_2133/tabs/region_select.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'tabs/faq.dart';

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
        child: Stack(
          children: [
            GoogleMap(
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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerButton(context, "Select Region(s)", () async {
                    showDialog(
                      context: context,
                      builder: (_) => region(context),
                    );
                  }),
                  headerButton(context, "Contact Us", () async {
                    showDialog(
                        context: context,
                        builder: (_) => contact(context)
                    );
                  }),
                  headerButton(context, "FAQ", () async {
                     showDialog(
                         context: context,
                         builder: (_) => faq(context)
                     );
                  }),
                  headerButton(context, "My Saved", (){}),
                  headerButton(context, "Login", () {
                    Navigator.pushNamed(context, '/login');
                  })
                ],
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