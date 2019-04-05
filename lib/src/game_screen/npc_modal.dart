import 'package:dev_rpg/src/game_screen/npc_style.dart';
import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/widgets/buttons/wide_button.dart';
import 'package:dev_rpg/src/widgets/prowess_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flare_flutter/flare_controls.dart';

/// Displays the stats of an [Npc] and offers the option to upgrade them.
class NpcModal extends StatelessWidget {
  final FlareControls _controls = FlareControls();
  @override
  Widget build(BuildContext context) {
    var npc = Provider.of<Npc>(context);
    var npcStyle = NpcStyle.from(npc);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280.0),
          child: Material(
            borderOnForeground: false,
            color: Colors.transparent,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(241, 241, 241, 1.0),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: FlareActor(npcStyle.flare,
                          alignment: Alignment.topCenter,
                          shouldClip: false,
                          fit: BoxFit.contain,
                          animation: "idle",
                          controller: _controls),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ButtonTheme(
                        minWidth: 0.0,
                        child: FlatButton(
                          padding: const EdgeInsets.all(0.0),
                          shape: null,
                          onPressed: () => Navigator.pop(context, null),
                          child: const Icon(
                            Icons.cancel,
                            color: Color.fromRGBO(69, 69, 82, 1.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Level ${npc.level}",
                        style: const TextStyle(
                          fontFamily: "MontserratRegular",
                          fontSize: 16,
                          color: Color.fromRGBO(111, 111, 118, 1.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0, bottom: 6.0),
                        child: Text(
                          npcStyle.name,
                          style: const TextStyle(
                            fontFamily: "MontserratRegular",
                            fontSize: 24,
                            color: Color.fromRGBO(38, 38, 47, 1.0),
                          ),
                        ),
                      ),
                      Text(
                        npcStyle.description,
                        style: const TextStyle(
                          fontFamily: "MontserratRegular",
                          fontSize: 14,
                          color: Color.fromRGBO(111, 111, 118, 1.0),
                        ),
                      ),
                      Column(
                        children: npc.prowess.keys
                            .map(
                              (Skill skill) => Padding(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Row(children: [
                                              const Icon(Icons.chevron_right,
                                                  color: Color.fromRGBO(
                                                      5, 59, 73, 1.0)),
                                              const SizedBox(width: 4),
                                              Text(
                                                skillDisplayName[skill],
                                                style: const TextStyle(
                                                  fontFamily:
                                                      "MontserratRegular",
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      5, 59, 73, 1.0),
                                                ),
                                              )
                                            ]),
                                            Expanded(child: Container()),
                                            Text(
                                              npc.prowess[skill].toString(),
                                              style: const TextStyle(
                                                fontFamily: "MontserratRegular",
                                                fontSize: 24,
                                                color: Color.fromRGBO(
                                                    38, 38, 47, 1.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: ProwessProgress(
                                              color: skillColor[skill],
                                              progress:
                                                  npc.prowess[skill] / 100),
                                        )
                                      ],
                                    ),
                                  ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 40),
                      WideButton(
                        onPressed: () {
                          if (npc.canUpgrade && npc.upgrade()) {
                            _controls.play("success");
                          }
                        },
                        paddingTweak: const EdgeInsets.only(right: -7.0),
                        background: npc.canUpgrade
                            ? const Color.fromRGBO(84, 114, 239, 1.0)
                            : const Color.fromRGBO(38, 38, 47, 0.1),
                        child: Row(
                          children: [
                            Text(
                              npc.isHired ? "UPGRADE" : "HIRE",
                              style: TextStyle(
                                fontFamily: "MontserratMedium",
                                fontSize: 16,
                                color: npc.canUpgrade
                                    ? Colors.white
                                    : const Color.fromRGBO(38, 38, 47, 0.25),
                              ),
                            ),
                            Expanded(child: Container()),
                            const Icon(Icons.stars,
                                color: Color.fromRGBO(249, 209, 81, 1.0)),
                            const SizedBox(width: 4),
                            Text(
                              npc.upgradeCost.toString(),
                              style: TextStyle(
                                fontFamily: "MontserratMedium",
                                fontSize: 14,
                                color: npc.canUpgrade
                                    ? const Color.fromRGBO(241, 241, 241, 1.0)
                                    : const Color.fromRGBO(38, 38, 47, 0.25),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
