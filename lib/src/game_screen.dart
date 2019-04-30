import 'dart:async';

import 'package:dev_rpg/src/rpg_layout_builder.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/widgets/restart_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_screen_slim.dart';
import 'game_screen_wide.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer _inactivityTimer;

  void _scheduleInactivityTimer(BuildContext context) {
    _inactivityTimer?.cancel();
    _inactivityTimer =
        Timer(Duration(seconds: 10), () => _inactivityDetected(context));
  }

  void _inactivityDetected(BuildContext context) {
    var world = Provider.of<World>(context);
    showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => RestartModal(world))
        .then((_) => _scheduleInactivityTimer(context));
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _scheduleInactivityTimer(context);
      },
      child: RpgLayoutBuilder(
        builder: (context, layout) =>
            layout == RpgLayout.wide ? GameScreenWide() : GameScreenSlim(),
      ),
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }
}
