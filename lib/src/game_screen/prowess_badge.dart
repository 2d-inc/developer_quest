import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:flutter/material.dart';

class ProwessBadge extends StatelessWidget {
  final Map<Skill, int> prowess;

  ProwessBadge(this.prowess);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: prowess.entries
          .map((e) => SkillBadge(e.key, e.value))
          .toList(growable: false),
    );
  }
}
