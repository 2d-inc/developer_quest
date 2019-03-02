import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:flutter/material.dart';

Map<Skill, String> skillDisplayName = {
  Skill.Coding: "Code",
  Skill.Design: "Design",
  Skill.UX: "UX",
  Skill.ProjectManagement: "Project Management"
};

Map<Skill, Color> skillColor = {
  Skill.Coding: Colors.blueGrey,
  Skill.Design: Colors.deepPurple,
  Skill.UX: Colors.deepOrange,
  Skill.ProjectManagement: Colors.lightGreen
};

class SkillBadge extends StatelessWidget {
  final Skill skill;
  final double value;

  SkillBadge(this.skill, [this.value]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:5.0),
      child: Container(
		padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: skillColor[skill],
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Text(skillDisplayName[skill] + (value != null ? " (${value.round()})" : ""), style:TextStyle(fontSize: 10.0, color:Colors.white))),
    );
  }
}
