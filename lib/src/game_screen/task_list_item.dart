import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  TaskListItem({@required this.task, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Card(
        child: InkWell(
          onTap: () async {
            var npcs = await showModalBottomSheet<Set<Npc>>(
              context: context,
              builder: (context) => TeamPickerModal(task),
            );
            _onAssigned(task, npcs);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(task.blueprint.name, style: TextStyle(fontSize: 14)),
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
                child: Provide<Task>(
                  builder: (context, child, snapshot) =>
                      LinearProgressIndicator(value: snapshot.percentComplete),
                ),
              ),
              Provide<Task>(builder: (context, child, snapshot) {
                if (snapshot.assignedTeam == null) return SizedBox();
                return Container(
                  height: 100.0,
                  color: Colors.deepOrange,
                  child: InkWell(
                    onTap: () => snapshot.boost += 2.5,
                    child: Text('Team Pic Goes Here... assigned to: '
                        '${snapshot.assignedTeam}. Tap to boost.'),
                  ),
                );
              }),
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
