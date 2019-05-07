import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/flare/skill_icon.dart';
import 'package:flutter/material.dart';

Map<Skill, String> skillDisplayName = {
  Skill.coding: 'Coding',
  Skill.engineering: 'Engineering',
  Skill.ux: 'UX',
  Skill.coordination: 'Coordination'
};

/// Displays a skill in a nicely readable format along with
/// the value if present.
class SkillBadge extends StatelessWidget {
  final Skill skill;

  const SkillBadge(this.skill);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: skillColor[skill],
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: [
            SkillIcon(skill),
            const SizedBox(width: 5),
            Text(
              skillDisplayName[skill].toUpperCase(),
              style:
                  buttonTextStyle.apply(fontSizeDelta: -4, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
