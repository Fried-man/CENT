import 'package:genome_2133/data/basic_tiles.dart';
import 'package:genome_2133/main.dart';
//import 'package:genome_2133/model/basic_tile.dart';
import 'package:genome_2133/utils.dart';
import 'package:flutter/material.dart';

import '../faq.dart';
import '../model/answer_tile.dart';

class BasicTilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(Faq.title),
      centerTitle: true,
    ),
    body: ListView(
      children:
      answerTiles.map((tile) => BasicTileWidget(tile: tile)).toList(),
    ),
  );
}

class BasicTileWidget extends StatelessWidget {
  final AnswerTile tile;

  const BasicTileWidget({
    Key key,
    required this.tile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = tile.title;
    final tiles = tile.tiles;

    if (tiles.isEmpty) {
      return ListTile(
        title: Text(title),
        onTap: () => Utils.showSnackBar(
          context,
          text: 'Clicked on: $title',
          color: const Color(0xff445756),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: ExpansionTile(
          key: PageStorageKey(title),
          title: Text(title),
          children: tiles.map((tile) => BasicTileWidget(tile: tile)).toList(),
        ),
      );
    }
  }
}
