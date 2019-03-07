import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:flutter/material.dart';

/// Displays the stats of an [Npc] and offers the option to upgrade them.
class NpcModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Provide<Npc>(builder: (context, _, npc) => Text(npc.name)),
      content: Provide<Npc>(
        builder: (context, _, npc) => Column(
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
      ),
      actions: [
        Provide<Npc>(builder: (context, child, npc) {
          return new FlatButton(
            child: Text("Upgrade: ${npc.upgradeCost}"),
            onPressed: npc.canUpgrade ? npc.upgrade : null,
          );
        }),
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
