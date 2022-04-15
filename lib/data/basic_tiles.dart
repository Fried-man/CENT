import '../model/answer_tile.dart';

final answerTiles = <AnswerTile>[
  AnswerTile(title: 'General Questions', tiles: [
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
  AnswerTile(title: 'Account Questions', tiles: [
    AnswerTile(title: 'What can I do with this app?'),
  ]),
  AnswerTile(title: 'Errors', tiles: [
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
