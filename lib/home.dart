import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genome_2133/tabs/contact.dart';
import 'package:genome_2133/tabs/region.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'main.dart';
import 'tabs/faq.dart';

late List<Window> windows;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late GoogleMapController _mapController;

  final LatLng _initMapCenter = const LatLng(20, 0);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void initState() {
    windows = [];
    super.initState();
  }

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
              initialCameraPosition: CameraPosition(
                  bearing: 0, target: _initMapCenter, tilt: 0, zoom: 3),
              onMapCreated: _onMapCreated,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerButton(context, "Select Region", () async {
                    showDialog(
                      context: context,
                      builder: (_) => Region(mapController: _mapController, updateParent: () {
                        setState(() {});
                      }),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          windows.add(value[0]);
                        });
                      }
                    });
                  }),
                  headerButton(context, "Contact Us", () async {
                    showDialog(
                        context: context, builder: (_) => contact(context));
                  }),
                  headerButton(context, "FAQ", () async {
                    showDialog(context: context, builder: (_) => faq(context));
                  }),
                  if (user != null)
                    headerButton(context, "My Saved", () {
                      Navigator.pushNamed(context, '/saved');
                    }),
                  headerButton(context, user == null ? "Login" : "Log Out",
                      () async {
                    if (user == null) {
                      Navigator.pushNamed(context, '/login')
                          .then((value) => setState(() {}));
                    } else {
                      await FirebaseAuth.instance.signOut().then((value) {
                        user = null;
                        setState(() {});
                      });
                    }
                  })
                ],
              ),
            ),
            for (Widget pane in windows) pane,
          ],
        ),
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
                fontSize: MediaQuery.of(context).size.width / 50,
                color: Colors.black),
          ),
        ),
      ),
    ),
  );
}
