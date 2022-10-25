import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home.dart';

class VariantCard extends StatefulWidget {
  final Map variant;
  final Function updateParent;

  const VariantCard(
      {Key? key, required this.variant, required this.updateParent})
      : super(key: key);

  @override
  State<VariantCard> createState() => _VariantCard();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return variant["accession"];
  }

  Offset getPosition() => const Offset(0, 0);

  void updatePosition(Offset newPosition) {}
}

class _VariantCard extends State<VariantCard> {
  bool isClosed = false;
  late int fakeCount;

  // turned off random placement so that it sits to right
  Offset position = Offset(
      ((window.physicalSize / window.devicePixelRatio).width -
          (window.physicalSize / window.devicePixelRatio).width / 3),
      ((window.physicalSize / window.devicePixelRatio).height -
          (window.physicalSize / window.devicePixelRatio).height / 2 - 225));

  getPosition() => position;

  void updatePosition(Offset newPosition) =>
      setState(() => position = newPosition);

  @override
  void initState() {
    fakeCount = Random().nextInt(30) + 12;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isClosed) return Container();

    void riseStack() {
      // Change stack function
      if (widget == windows.last) return;

      // TODO: fix position swap bug
      /*windows.remove(widget);
      windows.add(widget);

      widget.updateParent();*/
    }

    Widget content = SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 3,
      child: GestureDetector(
        onTap: () {
          riseStack();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Container(
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.height / 3.5,
                        child: AutoSizeText(
                          widget.variant["accession"],
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 40),
                        ),
                      ),
                      GestureDetector(
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // TODO: add cleanup to home array
                          setState(() {
                            isClosed = true;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Description: " + widget.variant["accession"],
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Region: " + widget.variant["geographical location"],
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Date Collected: " + widget.variant["date collected"].toString(),
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () => launchUrl(Uri.parse(
                                'https://www.ncbi.nlm.nih.gov/nuccore/' + widget.variant["accession"])),
                            child: const Text(
                              "Open in NCBI",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
          maxSimultaneousDrags: 1,
          feedback: Material(type: MaterialType.transparency, child: content),
          childWhenDragging: Container(),
          onDragEnd: (details) {
            updatePosition(details.offset);
            riseStack();
          },
          child: content),
    );
  }
}