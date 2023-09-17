import 'package:flutter/cupertino.dart';

import 'costume_button.dart';
import 'custom_text.dart';

class InfoAndNewGame extends StatelessWidget {
  final String goalTile;
  final Function reset;

  const InfoAndNewGame(
      {super.key, required this.goalTile, required this.reset});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: CostumeText(
        "Join the numbers and get to the $goalTile tile!",
        size: 14,
        weight: FontWeight.normal,
      )),
      const SizedBox(width: 20),
      CostumeButton("New Game", func: reset)
    ]);
  }
}