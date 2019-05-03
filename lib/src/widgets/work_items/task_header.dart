import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';

/// A header for [Task] indicating the rewarded coin and skills
/// necessary to work on the task.

class CoinImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 20,
        height: 20,
        child: const FlareActor('assets/flare/Coin.flr'),
      ),
      const SizedBox(width: 4)
    ]);
  }
}

