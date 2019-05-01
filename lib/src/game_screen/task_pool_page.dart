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

enum TaskPoolDisplay { all, inProgress, completed }

class TaskPoolPage extends StatelessWidget {
  final TaskPoolDisplay display;
  const TaskPoolPage({this.display = TaskPoolDisplay.all});

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
      color: const Color.fromRGBO(241, 241, 241, 1),
      child: Consumer<TaskPool>(
        builder: (context, taskPool) {
          return ListView(
            children: [
              const TasksButtonHeader(),
              const SizedBox(height: 12),
              ..._buildSection(
                "IN PROGRESS",
                taskPool.workItems,
              ),
              ..._buildSection(
                "COMPLETED",
                taskPool.completedTasks
                    .followedBy(taskPool.archivedTasks)
                    .toList(growable: false),
              )
            ],
          );
        },
      ),
    );
  }
}
