import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:flutter/material.dart';

/// Displays the stats of an [Npc] and offers the option to upgrade them.
class NpcModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProvideMulti(
        requestedValues: <Type>[User, Npc],
        builder: (context, _, values) {
          Npc npc = values.get<Npc>();
          User user = values.get<User>();

          return AlertDialog(
            title: new Text(npc.name),
            content: ProviderNode(
              providers: Providers.withProviders(
                {
                  Npc: Provider<Npc>.value(npc),
                  //User: Provider<User>.value(user)
                }
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: npc.prowess.keys
                    .map(
                      (Skill skill) => Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
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
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: Text("Upgrade: ${npc.upgradeCost}"),
                onPressed: user.coin >= npc.upgradeCost
                    ? () {
                        user.spend(npc.upgradeCost);
                        npc.upgrade();
                      }
                    : null,
              ),
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
