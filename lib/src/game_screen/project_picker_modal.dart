import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/task_tree/task_tree.dart';
import 'package:dev_rpg/src/shared_state/game/task_tree/tree_hierarchy.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/task_picker/task_picker_header.dart';
import 'package:dev_rpg/src/widgets/task_picker/task_picker_task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of the currently available [TaskBlueprint]s.
class ProjectPickerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskPool = Provider.of<TaskPool>(context);
    var _tasks = taskPool.availableTasks.toList(growable: false)
      ..sort((a, b) => -a.priority.compareTo(b.priority));
    List<FlattenedTreeData> flat = [];

    flattenTree(taskPool.beta.tasks, flat);
    List<Widget> flatTree = flat
        .map((flatTreeItem) => TaskPickerTask(
            blueprint: (flatTreeItem.data as TaskNode).blueprint,
			display: TaskDisplayState.locked,
            lines: flatTreeItem.lines,
            hasNextSibling: flatTreeItem.hasNextSibling,
            hasNextChild: flatTreeItem.hasNextChild))
        .toList();
    print("FLAT ${flatTree.length}");
    // List<Widget> tree = [];
    // if (_tasks.isNotEmpty) {
    //   tree.add(TaskPickerTask(
    //       blueprint: _tasks[0],
    //       lines: [true],
    //       hasNextSibling: true,
    //       hasNextChild: true));
    //   tree.add(TaskPickerTask(
    //       blueprint: _tasks[0],
    //       lines: [true, true],
    //       hasNextSibling: true,
    //       hasNextChild: false));
    //   tree.add(TaskPickerTask(
    //       blueprint: _tasks[0],
    //       lines: [true, true],
    //       hasNextSibling: true,
    //       hasNextChild: true));
    //   tree.add(TaskPickerTask(
    //       blueprint: _tasks[0],
    //       lines: [true, true, true],
    //       hasNextSibling: false,
    //       hasNextChild: false));
    //   tree.add(TaskPickerTask(
    //       blueprint: _tasks[0],
    //       lines: [true, true],
    //       hasNextSibling: false,
    //       hasNextChild: false));
    //   tree.add(TaskPickerTask(
    //       blueprint: _tasks[0],
    //       lines: [true],
    //       hasNextSibling: false,
    //       hasNextChild: false));
    // }
    var slivers = <Widget>[
      SliverPadding(
        padding: const EdgeInsets.only(top: 15.0),
        sliver: SliverPersistentHeader(
          pinned: false,
          delegate: const TaskPickerHeader("Alpha"),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return flatTree[index];
        }, childCount: flatTree.length),
      ),
      SliverPersistentHeader(
        pinned: false,
        delegate: const TaskPickerHeader("Beta"),
      ),
      SliverPersistentHeader(
        pinned: false,
        delegate: const TaskPickerHeader("Version 1.0", showLine: false),
      ),
    ];
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        color: modalBackgroundColor,
        child: CustomScrollView(slivers: slivers),
      ),
    );

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        color: modalBackgroundColor,
        child: ListView.builder(
          itemCount: _tasks.length + 1,
          itemBuilder: (context, index) {
            TaskBlueprint blueprint = index == 0 ? null : _tasks[index - 1];

            if (index == 0) {
              // TODO: extract this above the list view
              return const Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Text("AVAILABLE PROJECTS",
                      style: TextStyle(fontSize: 11)));
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
                        Text(blueprint.name,
                            style: const TextStyle(fontSize: 16)),
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
        ),
      ),
    );
  }
}
