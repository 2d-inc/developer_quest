import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

Map<Skill, String> skillDisplayName = {
  Skill.coding: "Coding",
  Skill.engineering: "Engineering",
  Skill.ux: "UX",
  Skill.coordination: "Coordination"
};

/// Displays a skill in a nicely readable format along with
/// the value if present.
class SkillBadge extends StatelessWidget {
  final Skill skill;
  final int value;

  const SkillBadge(this.skill, [this.value]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: skillColor[skill],
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Text(
          skillDisplayName[skill] +
              (value != null ? " (${value.round()})" : ""),
          style: const TextStyle(fontSize: 10.0, color: Colors.white),
        ),
      ),
    );
  }
}
