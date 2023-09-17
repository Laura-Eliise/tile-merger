import 'package:flutter/cupertino.dart';

import 'custom_text.dart';
import 'score_box.dart';

class TitleAndScore extends StatelessWidget {
  final String title;
  final int score;
  final int highScore;

  const TitleAndScore(
      {super.key,
      required this.title,
      required this.score,
      required this.highScore});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CostumeText(title),
      const Spacer(),
      ScoreBox(score: score),
      const SizedBox(width: 5),
      ScoreBox(highScore: highScore)
    ]);
  }
}