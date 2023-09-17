import 'package:flutter/material.dart';
import '../static/theme.dart';

class CostumeButton extends StatelessWidget {
  final Function func;
  final String text;
  final double horPadding;
  final double verPadding;

  const CostumeButton(this.text,
      {super.key,
      required this.func,
      this.horPadding = 10,
      this.verPadding = 5});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => {func()},
        style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                  vertical: verPadding, horizontal: horPadding),
            ),
            backgroundColor: MaterialStateProperty.all(buttonColor)),
        child: Text(
          text,
          style: const TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ));
  }
}
