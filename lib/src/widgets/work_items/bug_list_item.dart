import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/work_items/skill_dot.dart';
import 'package:dev_rpg/src/widgets/work_items/work_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a [Bug] that can be tapped on to assign it to a team.
class BugListItem extends StatelessWidget {
  static const Color accent = Color.fromRGBO(236, 41, 117, 1.0);
  @override
  Widget build(BuildContext context) {
    var bug = Provider.of<WorkItem>(context) as Bug;

    return WorkListItem(
      workItem: bug,
      isExpanded: bug.isBeingWorkedOn,
      progressColor: accent,
      heading: !bug.isComplete
          ? Row(
              children: [
                    const Icon(Icons.bug_report, color: accent),
                    Expanded(child: Container()),
                  ] +
                  bug.skillsNeeded
                      .map((Skill skill) => SkillDot(skill))
                      .toList())
          : const Icon(Icons.bug_report, color: disabledColor),
    );
  }
}
