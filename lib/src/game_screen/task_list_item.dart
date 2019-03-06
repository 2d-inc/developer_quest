import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:dev_rpg/src/shared_state/user.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  TaskListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProvideMulti(
        requestedValues: <Type>[Task, User],
        builder: (context, child, values) {
          Task task = values.get<Task>();
          User user = values.get<User>();
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Card(
              color:
                  task.state == TaskState.rewarded ? Colors.grey : Colors.white,
              child: InkWell(
                onTap: () {
                  switch (task.state) {
                    case TaskState.completed:
                      task.reward(user);
                      break;
                    case TaskState.working:
                      showModalBottomSheet<Set<Npc>>(
                        context: context,
                        builder: (context) => TeamPickerModal(task),
                      ).then((npcs) => _onAssigned(task, npcs));
                      break;
                    default:
                      break;
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Text(task.blueprint.name,
                              style: TextStyle(fontSize: 14)),
                          task.state != TaskState.completed
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    "REWARD!!",
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.black),
                                  ),
                                ),
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              children: task.blueprint.skillsNeeded
                                  .map((Skill skill) => SkillBadge(skill))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                          LinearProgressIndicator(value: task.percentComplete),
                    ),
                    task.assignedTeam == null
                        ? SizedBox()
                        : Container(
                            height: 100.0,
                            color: Colors.deepOrange,
                            child: InkWell(
                              onTap: () => task.boost += 2.5,
                              child: Text('Team Pic Goes Here... assigned to: '
                                  '${task.assignedTeam}. Tap to boost.'),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _onAssigned(Task task, Set<Npc> value) {
    if (value == null || value.isEmpty) return;
    task.assignTeam(value);
  }
}
