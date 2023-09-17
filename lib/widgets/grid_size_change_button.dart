import 'package:flutter/material.dart';
import '../static/theme.dart';

class GridSizeChangeButton extends StatelessWidget {
  final Function changeGridSize;
  final String text;

  const GridSizeChangeButton(
      {super.key, required this.changeGridSize, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: TextButton(
          onPressed: () => changeGridSize(),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: lightTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
