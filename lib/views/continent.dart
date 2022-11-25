import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContinentCard extends StatefulWidget {
  final String continent;
  final GoogleMapController mapController;
  final LatLng _initMapCenter = const LatLng(20, 0);
  final Function updateParent;

  const ContinentCard(
      {Key? key, required this.continent, required this.mapController, required this.updateParent})
      : super(key: key);

  @override
  State<ContinentCard> createState() => _ContinentCard();
}

class _ContinentCard extends State<ContinentCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Container()
                ],
              ),
            )
          ],
        )
    );
  }
}