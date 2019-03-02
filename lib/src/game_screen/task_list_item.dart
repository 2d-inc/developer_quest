import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  TaskListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<Task>(
      builder: (context, child, task) => Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Card(
            //margin: EdgeInsets.all(8),
            child: InkWell(
              onTap: () => showModalBottomSheet<Set<Npc>>(
                    context: context,
                    builder: (context) => TeamPickerModal(task),
                  ).then((npcs) => _onAssigned(task, npcs)),
              child: Column(
				  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(children: <Widget>[
                      Text(task.blueprint.name, style: TextStyle(fontSize: 14)),
                      Expanded(
                          child: Wrap(
                              alignment: WrapAlignment.end,
                              children: task.blueprint.requirements
                                  .map((Skill skill) => SkillBadge(skill))
                                  .toList()))
                    ]),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: LinearProgressIndicator(value: task.percentComplete),
                  ),
                  task.assignedTeam == null
                        ? SizedBox()
                        : Container(
							//padding: const EdgeInsets.all(20.0), 
							height:100.0, 
							color: Colors.deepOrange, child:InkWell(
                            onTap: () => task.boost += 2.5,
                            child: Text('Team Pic Goes Here... assigned to: ${task.assignedTeam}. Tap to boost.'))),
                ],
              ),
            ),
          )),
    );
  }

  void _onAssigned(Task task, Set<Npc> value) {
    if (value == null || value.isEmpty) return;
    task.assignTeam(value);
  }
}
