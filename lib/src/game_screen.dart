import 'package:flutter/material.dart';
import 'game_screen_slim.dart';
import 'game_screen_wide.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => orientation == Orientation.portrait
          ? GameScreenSlim()
          : GameScreenWide(),
    );
  }
}
