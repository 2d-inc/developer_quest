import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/provider.dart';
import 'package:flutter/material.dart';

class ProjectPickerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<TaskPool>(
      builder: (context, child, taskPool) {
        var _tasks = taskPool.availableTasks.toList(growable: false);

        return ListView.builder(
          itemCount: _tasks.length + 1,
          itemBuilder: (context, index) {
            TaskBlueprint blueprint = index == 0 ? null : _tasks[index - 1];

            if (index == 0) {
              // TODO: extract this above the list view
              return Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Text("AVAILABLE PROJECTS",
                      style: TextStyle(fontSize: 11)));
            }

            return Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                margin: EdgeInsets.zero,
                child: InkWell(
                  onTap: () => Navigator.pop(context, blueprint),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(blueprint.name, style: TextStyle(fontSize: 16)),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Text("COMPLETION REWARD:",
                              style: TextStyle(fontSize: 11)),
                        ),
                        Row(children: <Widget>[
                          Icon(Icons.stars, size: 16),
                          Text(blueprint.xpReward.toString(),
                              style: TextStyle(fontSize: 12))
                        ]),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 5.0),
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
      },
    );
  }
}
