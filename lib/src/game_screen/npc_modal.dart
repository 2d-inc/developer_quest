import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:flutter/material.dart';

/// Displays the stats of an [Npc] and offers the option to upgrade them.
class NpcModal extends StatelessWidget {
  final Npc npc;

  NpcModal({this.npc, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // Animation is a misnomer here. This is basically a ListenableBuilder.
      animation: npc,
      builder: (context, child) {
        return AlertDialog(
          title: Text(npc.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: npc.prowess.keys
                .map(
                  (Skill skill) => Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SkillBadge(skill),
                                Expanded(
                                  child: Text(
                                    npc.prowess[skill].toString(),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: LinearProgressIndicator(
                                  value: npc.prowess[skill] / 100),
                            )
                          ],
                        ),
                      ),
                )
                .toList(),
          ),
          actions: [
            FlatButton(
              child: Text("Upgrade: ${npc.upgradeCost}"),
              // TODO: fix for the case when company gets (or spends) some money
              //       while this modal is open
              onPressed: npc.canUpgrade ? npc.upgrade : null,
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
