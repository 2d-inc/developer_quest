import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/style_sphinx/sphinx_screen.dart';
import 'package:dev_rpg/src/widgets/work_items/task_header.dart';
import 'package:dev_rpg/src/widgets/work_items/work_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_over.dart';

/// Displays a [Task] that can be tapped on to assign it to a team.
/// The task can also be tapped on to award points once it is completed.
class TaskListItem extends StatelessWidget {
	
  bool _handleTap(Task task, BuildContext context) {

    if (task.state == TaskState.completed) {
      task.shipFeature();
      switch (task.blueprint.miniGame) {
        case MiniGame.none:
          break;
        case MiniGame.chomp:
          break;
        case MiniGame.sphinx:
          {
            // Time to face the Sphinx, game is effectively over.
            var world = Provider.of<World>(context);
            world.pause();

            Navigator.of(context)
                .pushNamed(SphinxScreen.miniGameRouteName)
                .then((_) {
					print("ESCAPED IT?");
              // Escaped the Sphinx.
              showDialog<void>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return GameOver(world);
                  });
            });
            break;
          }
      }

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
      handleTap: () => _handleTap(task, context),
      progressColor: const Color.fromRGBO(0, 152, 255, 1.0),
      heading: task.state != TaskState.rewarded
          ? TaskHeader(task.blueprint)
          : const Icon(Icons.check_circle, color: disabledColor),
    );
  }
}
