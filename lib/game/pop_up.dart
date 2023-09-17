import 'package:flutter/cupertino.dart';

import '../static/constants.dart';
import '../static/theme.dart';
import '../widgets/costume_button.dart';

class PopUp extends StatelessWidget {
  final String warning;
  final Function yesFunc;
  final Function noFunc;

  const PopUp({
    super.key,
    required this.yesFunc,
    required this.noFunc, required this.warning,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var width = constraints.maxWidth;
      return Container(
        height: width,
        width: width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: tileColors[0]?.withOpacity(0.85)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Expanded(
            //     child: 
                Text(
              warning,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: lightTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
            const Expanded(
                child: Text(
              "This will reset your game progress!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: lightTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100,
                    width: 120,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: CostumeButton(
                          "Yes!",
                          func: () => {yesFunc(width)},
                        ))),
                        const SizedBox(width: 50),
                SizedBox(
                    height: 100,
                    width: 120,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: CostumeButton(
                          "No!",
                          func: () => {noFunc()},
                        )))
              ],
            )
          ],
        )),
      );
    });
  }
}
