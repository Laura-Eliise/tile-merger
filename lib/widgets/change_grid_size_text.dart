import 'package:flutter/cupertino.dart';

import '../static/constants.dart';
import 'custom_text.dart';
import 'grid_size_change_button.dart';

class ChangeGridSizeText extends StatelessWidget {
  final Function decreaseGridSize;
  final Function increaseGridSize;

  const ChangeGridSizeText(
      {super.key,
      required this.decreaseGridSize,
      required this.increaseGridSize,});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CostumeText("Grid size:", size: 20),
        const SizedBox(width: 10),
        CostumeText("${minTileCount - 1} <  ", size: 20),
        CostumeText("$gridTileCount", size: 20),
        CostumeText("  < ${maxTileCount + 1}", size: 20),
        const Spacer(),
        GridSizeChangeButton(changeGridSize: decreaseGridSize, text: "-"),
        const SizedBox(width: 2),
        GridSizeChangeButton(changeGridSize: increaseGridSize, text: "+"),
      ],
    );
  }
}