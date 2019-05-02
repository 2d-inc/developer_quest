import 'package:dev_rpg/src/game_screen/bug_picker_modal.dart';
import 'package:dev_rpg/src/game_screen/project_picker_modal.dart';
import 'package:dev_rpg/src/game_screen/task_buttons.dart';
import 'package:dev_rpg/src/game_screen/task_pool_page.dart';
import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/style.dart';
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
  /// This returns slivers to be used in a [SliverList].
  void _buildSection(
      List<Widget> slivers, String title, List<WorkItem> workItems) {
    if (workItems.isNotEmpty) {
      slivers.add(SliverPersistentHeader(
        pinned: false,
        delegate: TasksSectionHeaderThree(title),
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
    return Container(
      color: display == TaskPoolDisplay.completed
          ? const Color.fromRGBO(229, 229, 229, 1)
          : const Color.fromRGBO(241, 241, 241, 1),
      child: Consumer<TaskPool>(
        builder: (context, taskPool) {
          var slivers = <Widget>[];

          // Add the header only if we show the in progress tasks.
          if (display == TaskPoolDisplay.all ||
              display == TaskPoolDisplay.inProgress) {
            slivers.add(
              SliverPersistentHeader(
                pinned: false,
                delegate: TasksButtonHeaderThree(taskPool: taskPool),
              ),
            );
            _buildSection(slivers, 'IN PROGRESS', taskPool.workItems);
          }

          if (display == TaskPoolDisplay.all ||
              display == TaskPoolDisplay.completed) {
            _buildSection(
                slivers,
                'COMPLETED',
                taskPool.completedTasks
                    .followedBy(taskPool.archivedTasks)
                    .toList(growable: false));
          }
          return CustomScrollView(slivers: slivers);
        },
      ),
    );
  }
}

class TasksSectionHeaderThree extends SliverPersistentHeaderDelegate {
  final String title;
  const TasksSectionHeaderThree(this.title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        title,
        style: buttonTextStyle.apply(
            fontSizeDelta: -4, color: secondaryContentColor),
      ),
    );
  }

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(TasksSectionHeaderThree oldDelegate) {
    return title != oldDelegate.title;
  }
}

class TasksButtonHeaderThree extends SliverPersistentHeaderDelegate {
  final TaskPool taskPool;
  const TasksButtonHeaderThree({this.taskPool});

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
                  Provider.of<TaskPool>(context, listen: false)
                      .startTask(project);
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AddTaskButton(
              'Bugs',
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 55;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}