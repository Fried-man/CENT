import 'package:meta/meta.dart';

class AnswerTile {
  final String title;
  final List<AnswerTile> tiles;

  const AnswerTile({
    required this.title,
    this.tiles = const [],
  });
}