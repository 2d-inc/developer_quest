import 'package:dev_rpg/src/game_screen/task_pool_page.dart';
import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/widgets/work_items/bug_list_item.dart';
import 'package:dev_rpg/src/widgets/work_items/task_list_item.dart';
import 'package:dev_rpg/src/widgets/work_items/tasks_button_header.dart';
import 'package:dev_rpg/src/widgets/work_items/tasks_section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of the [Task]s the player has interacted with.
/// These are [Task]s that have been added into the game, are being
/// actively worked on, or have been completed and/or archived.
class ThreeColTaskPoolPage extends StatelessWidget {
  final TaskPoolDisplay display;
  const ThreeColTaskPoolPage({this.display = TaskPoolDisplay.all});

  /// Builds a section of the task list with [title] and a list of [workItems].
  List<Widget> _buildSection(String title, List<WorkItem> workItems) {
    if (workItems.isNotEmpty) {
      return [
        TasksSectionHeader(title),
        ...workItems.map(
          (WorkItem item) => ChangeNotifierProvider<WorkItem>.value(
                notifier: item,
                key: ValueKey(item),
                child: item is Bug ? BugListItem() : TaskListItem(),
              ),
        ),
      ];
    }
    return <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _displayColor,
      child: Consumer<TaskPool>(
        builder: (context, taskPool) {
          var children = <Widget>[];
          if (display == TaskPoolDisplay.all ||
              display == TaskPoolDisplay.inProgress) {
            children = [
              const TasksButtonHeader(),
              const SizedBox(height: 12.0),
              ..._buildSection(
                "IN PROGRESS",
                taskPool.workItems,
              )
            ];
          } else {
            children = _buildSection(
            "COMPLETED",
            taskPool.completedTasks
              .followedBy(taskPool.archivedTasks)
              .toList(growable: false),
          );
          }
          return ListView(
            children: children,
          );
        },
      ),
    );
  }

  Color get _displayColor => display == TaskPoolDisplay.completed
      ? const Color.fromRGBO(229, 229, 229, 1)
      : const Color.fromRGBO(241, 241, 241, 1);
}
