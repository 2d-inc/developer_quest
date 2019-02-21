import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  TaskListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<Task>(
      builder: (context, child, task) => Card(
            margin: EdgeInsets.all(8),
            child: InkWell(
              onTap: () => showModalBottomSheet<Set<Npc>>(
                    context: context,
                    builder: (context) => TeamPickerModal(task),
                  ).then((npcs) => _onAssigned(task, npcs)),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(task.blueprint.name,
                      style: Theme.of(context).textTheme.title),
                  SizedBox(height: 10),
                  task.assignedTeam == null
                      ? SizedBox()
                      : Text('Assigned to: ${task.assignedTeam}'),
                  SizedBox(height: 10),
                  task.isBlocked
                      ? MaterialButton(
                          onPressed: () => task.resolveIssue(),
                          color: Colors.red,
                          child: Row(
                            children: [
                              Icon(Icons.warning),
                              Text('BLOCKING ISSUE'),
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 10),
                  LinearProgressIndicator(value: task.percentComplete),
                ],
              ),
            ),
          ),
    );
  }

  void _onAssigned(Task task, Set<Npc> value) {
    if (value == null || value.isEmpty) return;
    task.assignTeam(value);
  }
}
