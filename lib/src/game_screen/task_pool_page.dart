import 'package:dev_rpg/src/rpg_layout_builder.dart';
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

/// Displays a list of the [Task]s the player has interacted with.
/// These are [Task]s that have been added into the game, are being
/// actively worked on, or have been completed and/or archived.
class TaskPoolPage extends StatelessWidget {
  final TaskPoolDisplay display;
  const TaskPoolPage({this.display = TaskPoolDisplay.all});

  /// Builds a section of the task list with [title] and a list of [workItems].
  /// This returns slivers to be used in a [SliverList].
  void _buildSection(List<Widget> slivers, String title, double scale,
      List<WorkItem> workItems) {
    if (workItems.isNotEmpty) {
      slivers.add(SliverPersistentHeader(
        pinned: false,
        delegate: TasksSectionHeader(title, scale),
      ));
      slivers.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          WorkItem item = workItems[index];
          return ChangeNotifierProvider<WorkItem>.value(
            notifier: item,
            key: ValueKey(item),
            child: item is Bug ? BugListItem() : TaskListItem(),
          );
        }, childCount: workItems.length),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RpgLayoutBuilder(builder: (context, layout) {
      double scale = layout == RpgLayout.ultrawide ? 1.25 : 1;
      return Container(
        color: display == TaskPoolDisplay.completed
            ? const Color.fromRGBO(229, 229, 229, 1)
            : const Color.fromRGBO(241, 241, 241, 1),
        child: Consumer<TaskPool>(
          builder: (context, taskPool, _) {
            var slivers = <Widget>[];

            // Add the header only if we show the in progress tasks.
            if (display == TaskPoolDisplay.all ||
                display == TaskPoolDisplay.inProgress) {
              slivers.add(
                SliverPersistentHeader(
                  pinned: false,
                  delegate: TasksButtonHeader(taskPool: taskPool, scale: scale),
                ),
              );
              _buildSection(slivers, 'IN PROGRESS', scale, taskPool.workItems);
            }

            if (display == TaskPoolDisplay.all ||
                display == TaskPoolDisplay.completed) {
              _buildSection(
                  slivers,
                  'COMPLETED',
                  scale,
                  taskPool.completedTasks
                      .followedBy(taskPool.archivedTasks)
                      .toList(growable: false));
            }
            return CustomScrollView(slivers: slivers);
          },
        ),
      );
    });
  }
}
