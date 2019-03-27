import 'package:dev_rpg/src/style_sphinx/sphinx_screen.dart';
import 'package:flutter_web/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SphinxScreen(),
    );
  }
}
