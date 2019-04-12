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
class TaskPoolPage extends StatelessWidget {
  List<Widget> makeWorkSectionSlivers(String title, List<WorkItem> workItems) {
    if (workItems.isNotEmpty) {
      return [
        SliverPersistentHeader(
          pinned: false,
          delegate: TasksSectionHeader(title),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            WorkItem item = workItems[index];
            return ChangeNotifierProvider<WorkItem>(
              notifier: item,
              key: ValueKey(item),
              child: item is Bug ? BugListItem() : TaskListItem(),
            );
          }, childCount: workItems.length),
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(241, 241, 241, 1.0),
      child: Consumer<TaskPool>(
        builder: (context, taskPool) {
          return CustomScrollView(
              slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: TasksButtonHeader(taskPool: taskPool),
                    ),
                  ] +
                  makeWorkSectionSlivers("IN PROGRESS", taskPool.workItems) +
                  makeWorkSectionSlivers(
                      "COMPLETED",
                      taskPool.completedTasks
                          .followedBy(taskPool.archivedTasks)
                          .toList(growable: false)));
        },
      ),
    );
  }
}
