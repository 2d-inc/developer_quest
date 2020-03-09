import 'package:dev_rpg/src/game_screen/add_task_button.dart';
import 'package:dev_rpg/src/game_screen/bug_picker_modal.dart';
import 'package:dev_rpg/src/game_screen/project_picker_modal.dart';
import 'package:dev_rpg/src/game_screen/team_picker_modal.dart';
import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is a header providing two buttons, one for selecting tasks and another
/// for selecting active bugs to add to the working list.
class TasksButtonHeader extends SliverPersistentHeaderDelegate {
  final TaskPool taskPool;
  final double scale;
  const TasksButtonHeader({this.taskPool, this.scale});

  Future<void> _pickTeam(BuildContext context, WorkItem item) async {
    // immediately show the character picker for this newly
    // created task.
    var characters = await showModalBottomSheet<Set<Character>>(
      context: context,
      builder: (context) => TeamPickerModal(item),
    );
    if (characters != null && !item.isComplete) {
      item.assignTeam(characters.toList());
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
            child: AddTaskButton(
              'Tasks',
              scale: scale,
              key: const Key('add_task'),
              count: taskPool.availableTasks.length,
              icon: Icons.add,
              color: const Color(0xff5472ee),
              onPressed: () async {
                var project = await showModalBottomSheet<TaskBlueprint>(
                  context: context,
                  builder: (context) => ProjectPickerModal(),
                );
                if (project != null) {
                  var task = Provider.of<TaskPool>(context, listen: false)
                      .startTask(project);
                  await _pickTeam(context, task);
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AddTaskButton(
              'Bugs',
              scale: scale,
              count: taskPool.availableBugs.length,
              icon: Icons.bug_report,
              color: const Color(0xffeb2875),
              onPressed: () async {
                var bug = await showModalBottomSheet<Bug>(
                  context: context,
                  builder: (context) => BugPickerModal(),
                );
                if (bug != null) {
                  Provider.of<TaskPool>(context, listen: false)
                      .addWorkItem(bug);
                  await _pickTeam(context, bug);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 55 * scale;

  @override
  double get minExtent => 55 * scale;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
