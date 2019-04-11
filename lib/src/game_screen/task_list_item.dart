import 'package:dev_rpg/src/game_screen/launch_button.dart';
import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/tasks/skill_dot.dart';
import 'package:flare_flutter/flare_actor.dart';
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

  void _launch(WorkItem workItem) {
    if (workItem is Task) {
      switch (workItem.state) {
        case TaskState.completed:
          workItem.shipFeature();
          break;
        default:
          break;
      }
    }
  }

  void _onAssigned(WorkItem workItem, Set<Npc> value) {
    if (value == null || value.isEmpty) return;
    if (workItem.isComplete) return;
    workItem.assignTeam(value.toList());
  }

  @override
  Widget build(BuildContext context) {
    var task = Provider.of<WorkItem>(context) as Task;

    bool showSkillsDots = task.state != TaskState.completed;
    bool showLaunchButton = task.state == TaskState.completed;

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  offset: const Offset(0.0, 10.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(9.0)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              height:
                  task.isBeingWorkedOn || (task.state == TaskState.completed)
                      ? 140
                      : 0,
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(9.0),
                    topRight: Radius.circular(9.0)),
                color: const Color(0xFF2D344E),
              ),
            ),
            Stack(
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _handleTap(context, task),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          task.isComplete
                              ? const Icon(Icons.check_circle,
                                  color: disabledColor)
                              : Row(
                                  children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          child: const FlareActor(
                                              "assets/flare/Coin.flr"),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          task.blueprint.coinReward.toString(),
                                          style: contentSmallStyle,
                                        ),
                                        Expanded(child: Container()),
                                      ] +
                                      (showSkillsDots
                                          ? task.skillsNeeded
                                              .map((Skill skill) =>
                                                  SkillDot(skill))
                                              .toList()
                                          : []),
                                ),
                          const SizedBox(height: 12),
                          Text(task.name,
                              style: task.isComplete
                                  ? contentStyle.apply(color: disabledColor)
                                  : contentStyle)
                        ],
                      ),
                    ),
                  ),
                ),
                showLaunchButton
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: LaunchButton(
                            onPressed: () => _launch(task),
                          ),
                        ))
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BugListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bug = Provider.of<WorkItem>(context) as Bug;

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    offset: const Offset(0.0, 10.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(9.0)),
              color: Colors.white),
          child: Column(children: [
            Row(children: [
              Text(
                bug.name,
                style: contentSmallStyle,
              )
            ])
          ])),
    );
  }
}

class TaskListItemOld extends StatelessWidget {
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
                  Text(workItem.name,
                      style: TextStyle(fontSize: 14, color: Colors.black)),
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
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.black),
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
