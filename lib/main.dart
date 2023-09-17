import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'services/db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String title = "2048";
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (v) => runApp(
      LoadMyApp(
        fetch: DB().self,
        title: title,
      ),
    ),
  );
}
