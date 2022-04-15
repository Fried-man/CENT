import 'package:flutter/material.dart';

ListView faq (context) => recursiveList(QnA) as ListView;

Widget recursiveList (content) { // TODO: Implement Q&A collapsable widgets
  if (content is List) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: content.length,
        itemBuilder: (context, index) {
          if (content[index].containsKey("Question")) {
            return ListTile(
              title: Text(content[index]["Question"]),
              subtitle: Text(content[index]["Answer"]),
            );
          }
          return ListTile(
            title: Text(content[index]["Title"]),
            subtitle: recursiveList(content[index]["Content"]),
          );
      },
    );
  }
  return ListTile(
    title: Text(content["Question"]),
    subtitle: Text(content["Answer"]),
  );
}

/*class BasicTileWidget extends StatelessWidget {
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
}*/

List<Map> QnA = [
  {
    "Title" : "General Questions",
    "Content" : {
      "Question" : "What can I do with this app?",
      "Answer" : "The purpose of this application is to allow both researchers and the general"
    }
  },
  {
    "Title" : "Variant Questions",
    "Content" : [
      {
        "Question" : "Where do these variants come from?",
        "Answer" : "All of these variants are retrieved from the NCBI database"
      },
      {
        "Question" : "Where can I find more details?",
        "Answer" : 'To find more details on a variant click on the hyperlinked variant, '
            ' this will bring you to the NCBI details on that strand. Here you'
            ' will find both the FASTA download for the sequence and its ID.'
      },
      {
        "Question" : "How do I compare a variant against another variant",
        "Answer" : 'Right now you cannot as it is not implemented in this iteration. However,'
            ' in the future the summary for a variant will have'
      }
    ]
  },
  {
    "Title" : "Region Questions",
    "Content" : {
      "Question" : "Why separate based off region?",
      "Answer" : "Separating by region allows you to look at the developments of"
          " variants within a select area. As mutations may be influenced by the "
          "diversity of individuals within a region, as seen in areas of high "
          "travel, as  more variants are introduced into the pool of competition."
    }
  },
  {
    "Question" : "Account Questions",
    "Answer" : "What can I do with this app?"
  },
  {
    "Question" : "Errors",
    "Answer" : "What can I do with this app?"
  }
];
/*
final answerTiles = <AnswerTile>[
  const AnswerTile(title: '', tiles: [
    AnswerTile(title: ''),
  ]),
  AnswerTile(title: '', tiles: [
    AnswerTile(title: '', tiles: buildAnswersCome()),
    AnswerTile(title: '', tiles: buildAnswersDetails()),
    AnswerTile(title: '', tiles: buildAnswersComparison()),
  ]),
  AnswerTile(title: '', tiles: [
    AnswerTile(title: '',tiles: buildWhyRegion()),
  ]),
  const AnswerTile(title: '', tiles: [
    AnswerTile(title: ''),
  ]),
  const AnswerTile(title: '', tiles: [
    AnswerTile(title: ''),
  ]),
];
// General Questions
// Q1
List<AnswerTile> buildGenDo() => [
  '',
].map<AnswerTile>(buildAnswer).toList();

// Variant Questions
// Q1
List<AnswerTile> buildAnswersCome() => [
  '',
].map<AnswerTile>(buildAnswer).toList();
//Q2
List<AnswerTile> buildAnswersDetails() => [
  ,
].map<AnswerTile>(buildAnswer).toList();
//Q3
List<AnswerTile> buildAnswersComparison() => [
  ,
].map<AnswerTile>(buildAnswer).toList();

//Region Questions
//Q1
List<AnswerTile> buildWhyRegion() => [
  ,
].map<AnswerTile>(buildAnswer).toList();
//Q2
*/

/*AnswerTile buildAnswer(String answer) => AnswerTile(
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
}*/
