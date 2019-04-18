import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/work_items/skill_dot.dart';
import 'package:dev_rpg/src/widgets/work_items/work_list_item.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a [Task] that can be tapped on to assign it to a team.
/// The task can also be tapped on to award points once it is completed.
class TaskListItem extends StatelessWidget {
  bool _handleTap(Task task) {
    if (task.state == TaskState.completed) {
      task.shipFeature();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var task = Provider.of<WorkItem>(context) as Task;

    bool isExpanded = task.isBeingWorkedOn || task.state == TaskState.completed;
    return WorkListItem(
      workItem: task,
      isExpanded: isExpanded,
      handleTap: () => _handleTap(task),
      progressColor: const Color.fromRGBO(0, 152, 255, 1.0),
      heading: task.state != TaskState.rewarded
          ? Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  child: const FlareActor("assets/flare/Coin.flr"),
                ),
                const SizedBox(width: 4),
                Text(
                  task.blueprint.coinReward.toString(),
                  style: contentSmallStyle,
                ),
                Expanded(child: Container()),
              ]..addAll(
                  task.skillsNeeded
                      .map((Skill skill) => SkillDot(skill))
                      .toList(),
                ),
            )
          : const Icon(Icons.check_circle, color: disabledColor),
    );
  }
}
