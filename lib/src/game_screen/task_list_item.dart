import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a [Task] that can be tapped on to assign it to a team.
/// The task can also be tapped on to award points once it is completed.
class TaskListItem extends StatelessWidget {
  Future<void> _handleTap(BuildContext context, WorkItem workItem) async {
    if (workItem is Task) {
      switch (workItem.state) {
        case TaskState.completed:
          workItem.shipFeature();
          return;
        case TaskState.rewarded:
          return;
        default:
          break;
      }
    }
    var npcs = await showDialog<Set<Npc>>(
      context: context,
      builder: (context) => TeamPickerModal(workItem),
    );
    _onAssigned(workItem, npcs);
  }

  @override
  Widget build(BuildContext context) {
    var workItem = Provider.of<WorkItem>(context);
    return Card(
      color: workItem is Task && workItem.state == TaskState.rewarded
          ? Colors.grey
          : Colors.white,
      child: InkWell(
        onTap: () => _handleTap(context, workItem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(workItem.name, style: TextStyle(fontSize: 14)),
                  workItem is Task && workItem.state == TaskState.completed
                      ? Container(
                          margin: const EdgeInsets.only(left: 5.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            "Ship it!!",
                            style: TextStyle(
                                fontSize: 10.0, color: Colors.black),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: workItem.skillsNeeded
                          .map((Skill skill) => SkillBadge(skill))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LinearProgressIndicator(value: workItem.percentComplete),
            ),
            workItem.assignedTeam == null
                ? const SizedBox()
                : Container(
                    height: 100.0,
                    color: Colors.deepOrange,
                    child: InkWell(
                      onTap: workItem.addBoost,
                      child: Text('Team Pic Goes Here... assigned to: '
                          '${workItem.assignedTeam}. Tap to boost.'),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void _onAssigned(WorkItem workItem, Set<Npc> value) {
    if (value == null || value.isEmpty) return;
    if (workItem.isComplete) return;
    workItem.assignTeam(value.toList());
  }
}
