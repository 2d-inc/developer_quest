import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of the currently available [TaskBlueprint]s.
class ProjectPickerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskPool = Provider.of<TaskPool>(context);
    var _tasks = taskPool.availableTasks.toList(growable: false)
      ..sort((a, b) => -a.priority.compareTo(b.priority));

    return ListView.builder(
      itemCount: _tasks.length + 1,
      itemBuilder: (context, index) {
        TaskBlueprint blueprint = index == 0 ? null : _tasks[index - 1];

        if (index == 0) {
          // TODO: extract this above the list view
          return const Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child:
                  Text("AVAILABLE PROJECTS", style: TextStyle(fontSize: 11)));
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () => Navigator.pop(context, blueprint),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(blueprint.name, style: const TextStyle(fontSize: 16)),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text("COMPLETION REWARD:",
                          style: TextStyle(fontSize: 11)),
                    ),
                    Row(children: <Widget>[
                      const Icon(Icons.stars, size: 16),
                      Text(blueprint.userReward.toString(),
                          style: const TextStyle(fontSize: 12))
                    ]),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text("SKILLS REQUIRED:",
                          style: TextStyle(fontSize: 11)),
                    ),
                    Wrap(
                        children: blueprint.skillsNeeded
                            .map((Skill skill) => SkillBadge(skill))
                            .toList()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
