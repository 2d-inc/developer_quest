import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:flutter/material.dart';

class ProwessBadge extends StatelessWidget {
  final Map<Skill, double> prowess;

  ProwessBadge(this.prowess);

  @override
  Widget build(BuildContext context) {
    List<Widget> badges = [];
    prowess.forEach((Skill skill, double value) {
      badges.add(SkillBadge(skill, value));
    });
    return Wrap(alignment: WrapAlignment.end, children: badges);
  }
}
