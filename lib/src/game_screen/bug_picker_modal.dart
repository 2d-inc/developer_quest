import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of the currently available [Bug]s.
class BugPickerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskPool = Provider.of<TaskPool>(context);
    var bugs = taskPool.availableBugs.toList(growable: false)
      ..sort((a, b) => -a.priority.drainOfJoy.compareTo(b.priority.drainOfJoy));

    return ListView.builder(
      itemCount: bugs.length,
      itemBuilder: (context, index) {
        Bug bug = bugs[index];

        // We'll replace this with a shared widget for the Bug/Tasks that can be
        // used in both the pickers and the pool page when we start styling
        // these.
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () => Navigator.pop(context, bug),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(bug.name, style: const TextStyle(fontSize: 16)),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text("SKILLS REQUIRED:",
                          style: TextStyle(fontSize: 11)),
                    ),
                    Wrap(
                        children: bug.skillsNeeded
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
