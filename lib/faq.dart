import 'package:flutter/material.dart';
import 'package:genome_2133/utils.dart';

ListView faq (context) {
  return ListView(
    children: answerTiles.map((tile) => BasicTileWidget(tile: tile)).toList(),
  );
}

class BasicTileWidget extends StatelessWidget {
  final AnswerTile tile;

  const BasicTileWidget({
    Key? key,
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
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
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

final answerTiles = <AnswerTile>[
  const AnswerTile(title: 'General Questions', tiles: [
    AnswerTile(title: 'What can I do with this app?'),
  ]),
  AnswerTile(title: 'Variant Questions', tiles: [
    AnswerTile(title: 'Where do these variants come from?', tiles: buildAnswersCome()),
    AnswerTile(title: 'Where can I find more details?', tiles: buildAnswersDetails()),
    AnswerTile(title: 'How do I compare a variant against another variant', tiles: buildAnswersComparison()),
  ]),
  AnswerTile(title: 'Region Questions', tiles: [
    AnswerTile(title: 'Why separate based off region?',tiles: buildWhyRegion()),
  ]),
  const AnswerTile(title: 'Account Questions', tiles: [
    AnswerTile(title: 'What can I do with this app?'),
  ]),
  const AnswerTile(title: 'Errors', tiles: [
    AnswerTile(title: 'What can I do with this app?'),
  ]),
];
// General Questions
// Q1
List<AnswerTile> buildGenDo() => [
  'The purpose of this application is to allow both researchers and the general',
].map<AnswerTile>(buildAnswer).toList();

// Variant Questions
// Q1
List<AnswerTile> buildAnswersCome() => [
  'All of these variants are retrieved from the NCBI database',
].map<AnswerTile>(buildAnswer).toList();
//Q2
List<AnswerTile> buildAnswersDetails() => [
  'To find more details on a variant click on the hyperlinked variant, '
      ' this will bring you to the NCBI details on that strand. Here you'
      ' will find both the FASTA download for the sequence and its ID.',
].map<AnswerTile>(buildAnswer).toList();
//Q3
List<AnswerTile> buildAnswersComparison() => [
  'Right now you cannot as it is not implemented in this iteration. However,'
      ' in the future the summary for a variant will have',
].map<AnswerTile>(buildAnswer).toList();

//Region Questions
//Q1
List<AnswerTile> buildWhyRegion() => [
  'Separating by region allows you to look at the developments of variants'
      ' within a select area. As mutations may be influenced by the diversity'
      ' of individuals within a region, as seen in areas of high travel, as '
      ' more variants are introduced into the pool of competition. ',
].map<AnswerTile>(buildAnswer).toList();
//Q2


AnswerTile buildAnswer(String answer) => AnswerTile(
  title: answer,
  //tiles: List.generate(28, (index) => AnswerTile(title: '$index.'))
);

class AnswerTile {
  final String title;
  final List<AnswerTile> tiles;

  const AnswerTile({
    required this.title,
    this.tiles = const [],
  });
}