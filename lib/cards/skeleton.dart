import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:genome_2133/cards/country.dart';

import '../home.dart';

class SkeletonCard extends StatefulWidget {
  final Function updateParent;
  final String title;
  final Widget body;
  final Offset initPosition;
  final GlobalKey<_SkeletonCard> controlKey;

  const SkeletonCard(
      {
      required this.controlKey,
      required this.updateParent,
      required this.title,
      required this.body,
      this.initPosition = const Offset(0, 0)
      }) : super(key: controlKey);

  @override
  State<SkeletonCard> createState() => _SkeletonCard();

  Offset getPosition() => const Offset(0, 0);

  void updatePosition(Offset newPosition) {}
  Offset getDefaultPostion (Widget card) { return const Offset(0,0);}
}

class _SkeletonCard extends State<SkeletonCard> {
  bool isClosed = false;
  late Offset position;
  int size = 1000;
  bool isMoving = false;

  void updateState() {
    setState(() {});
  }

  getPosition() => position;

  updatePosition(Offset newPosition) =>
      setState(() => position = newPosition);

 getDefaultPostion (Widget card) {
    if (card is CountryCard) { // left
      return Offset(
          (window.physicalSize / window.devicePixelRatio).width / 8,
          ((window.physicalSize / window.devicePixelRatio).height -
              (window.physicalSize / window.devicePixelRatio).height / 2 -
              225));
    }

    return Offset( // right
        (window.physicalSize / window.devicePixelRatio).width  * (7/8) - size / 3,
        ((window.physicalSize / window.devicePixelRatio).height -
            (window.physicalSize / window.devicePixelRatio).height / 2 -
            225));
  }

  void updateActive ({bool isNew = false}) {
    if (windows.length == 1) return;

    setState(() {
      List<SkeletonCard> temp = List.from(windows);
      temp.remove(widget);
      temp.add(widget);
      windows = temp;
      if (!isNew) {
        widget.updateParent();
      }
    });
    windows[windows.length - 2].controlKey.currentState!.updateState();

  }

  @override
  void initState() {
    position = widget.initPosition;
    if (position == const Offset(0, 0)) {
      position = getDefaultPostion(widget.body);
    }
    updateActive(isNew: true);
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


    return Positioned(
      left: position.dx,
      top: position.dy,
      child: SizedBox(
        height: size / 2,
        width: size / 3,
        child: GestureDetector(
          onTap: () {
            updateActive();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: !isMoving ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  Draggable(
                    maxSimultaneousDrags: 1,
                    feedback: Material(
                        type: MaterialType.transparency,
                        child: SizedBox(
                      height: size / 2,
                      width: size / 3,
                      child: GestureDetector(
                        onTap: () {
                          riseStack();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: !isMoving ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  color: Theme.of(context).cardColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.title,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                          const TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                              onTap: () {
                                                // TODO: add cleanup to home array
                                                setState(() {
                                                  // need to handle cases where multiple cards?
                                                  if (widget.body is CountryCard) {
                                                    (widget.body as CountryCard).centerMap();
                                                  }
                                                  isClosed = true;
                                                });
                                              },
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: widget.body,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    ),
                    childWhenDragging: Container(),
                    onDragStarted: () {
                      isMoving = true;
                      updateActive();
                    },
                    onDragEnd: (details) {
                      isMoving = false;
                      updatePosition(details.offset);
                      riseStack();
                    },
                    child: Container(
                      height: 40,
                      color: windows.last == widget || isMoving ? Theme.of(context).cardColor : Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style:
                              const TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    // TODO: add cleanup to home array
                                    setState(() {
                                      // need to handle cases where multiple cards?
                                      if (widget.body is CountryCard) {
                                        (widget.body as CountryCard).centerMap();
                                      }
                                      isClosed = true;
                                    });
                                  },
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isMoving)
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: widget.body,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
