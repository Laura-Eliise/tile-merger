import 'package:flutter/material.dart';

import 'game/game.dart';
import 'services/db.dart';
import 'static/theme.dart';

class LoadMyApp extends StatelessWidget {
  final String title;
  final Future<dynamic> fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetch,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              decoration: const BoxDecoration(color: lightBackgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      color: tileColors.containsKey(2048)
                          ? tileColors[2048]
                          : Colors.amber,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.error != null) {
            throw Exception("Failed to get app data");
          } else {
            if (snapshot.hasData) {
              return StateManager(
                db: snapshot.data,
                title: title,
              );
            }
            throw Exception("No app data found");
          }
        });
  }

  const LoadMyApp({
    super.key,
    required this.fetch,
    required this.title,
  });
}

class StateManager extends StatelessWidget {
  final String title;
  final DB db;
  final Map<String, Widget Function(BuildContext)> routes;

  const StateManager({
    super.key,
    required this.title,
    required this.db,
    this.routes = const <String, WidgetBuilder>{},
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: getTheme(context),
      initialRoute: "/",
      routes: {
        "/": (context) => Game(title: title, db: db),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
