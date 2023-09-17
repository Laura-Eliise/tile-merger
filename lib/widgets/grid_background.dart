import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../static/theme.dart';
import '../static/constants.dart';

class GridBackground extends StatelessWidget {
  final int tileCount;
  const GridBackground({super.key, required this.tileCount});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double tileSize =
            (width - gridTileGap * (tileCount + 1)) / tileCount;
        return Container(
          height: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: darkBackgroundColor,
          ),
          padding: const EdgeInsets.all(gridTileGap / 2),
          child: Column(
            children: List.generate(
              tileCount,
              (index) => Row(
                children: List.generate(
                    tileCount,
                    (index) => Container(
                          width: tileSize,
                          height: tileSize,
                          margin: const EdgeInsets.all(gridTileGap / 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
                            color: tileColors[0],
                          ),
                        )),
              ),
            ),
          ),
        );
      },
    );
  }
}
