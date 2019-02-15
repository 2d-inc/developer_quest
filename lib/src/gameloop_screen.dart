import 'package:dev_rpg/src/gameloop_screen/list_item.dart';
import 'package:dev_rpg/src/shared_state/game/countdown_clock.dart';
import 'package:dev_rpg/src/shared_state/game/quests.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class GameloopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Provide<CountdownClock>(
          builder: (context, child, countdown) =>
              Text("${countdown.remainingTime.inSeconds}s"),
        ),
      ),
      body: Provide<Quests>(
        builder: (context, child, quests) {
          return ListView.builder(
            itemCount: quests.length,
            itemBuilder: (context, index) => QuestListItem(
                  quest: quests[index],
                  key: ValueKey(quests[index]),
                ),
          );
        },
      ),
    );
  }
}
