import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:flutter/material.dart';

Map<Skill, String> skillDisplayName = {
  Skill.coding: "Code",
  Skill.design: "Design",
  Skill.ux: "UX",
  Skill.projectManagement: "Project Management"
};

Map<Skill, Color> skillColor = {
  Skill.coding: Colors.blueGrey,
  Skill.design: Colors.deepPurple,
  Skill.ux: Colors.deepOrange,
  Skill.projectManagement: Colors.lightGreen
};

class SkillBadge extends StatelessWidget {
  final Skill skill;
  final int value;

  SkillBadge(this.skill, [this.value]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: skillColor[skill],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Text(
          skillDisplayName[skill] +
              (value != null ? " (${value.round()})" : ""),
          style: TextStyle(fontSize: 10.0, color: Colors.white),
        ),
      ),
    );
  }
}
