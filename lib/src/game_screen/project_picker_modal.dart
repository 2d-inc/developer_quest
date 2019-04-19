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

/// A pruned representation of the TaskNode. We use this to build up a tree of
/// tasks that makes sense given the current state of availability.
class _PrunedTaskNode implements TreeData {
  final TaskDisplayState display;
  final TaskBlueprint blueprint;
  @override
  List<_PrunedTaskNode> children;

  _PrunedTaskNode({this.blueprint, this.display});

  /// Find the deepest level of the tree that has an available item in it.
  /// Add it to the available list.
  void findTopLevelAvailable(List<_PrunedTaskNode> available) {
    bool hasVisibile = display == TaskDisplayState.available ||
        children.indexWhere(
                (child) => child.display == TaskDisplayState.available) !=
            -1;
    if (hasVisibile) {
      available.add(this);
    } else {
      for (final child in children) {
        child.findTopLevelAvailable(available);
      }
    }
  }

  bool pruneDeadBranches([_PrunedTaskNode parent]) {
    children.removeWhere((child) => child.pruneDeadBranches(this));
    return children.isEmpty &&
        display != TaskDisplayState.available &&
        (parent == null || parent.display != TaskDisplayState.available);
  }

  /// Remove nodes that have parents that are un-available.
  bool pruneNodesWithUnavailableParents([_PrunedTaskNode parent]) {
    if (display != TaskDisplayState.available &&
        parent != null &&
        parent.display != TaskDisplayState.available) {
      return true;
    } else {
      bool prune = false;
      for (final child in children) {
        if (child.pruneNodesWithUnavailableParents(this)) {
          prune = true;
          break;
        }
      }
      if (prune) {
        children.clear();
        // Prune ourselves if we have no children and
        // our state is not available.
        return display != TaskDisplayState.available;
      }
      return false;
    }
  }
}

/// Compute display data for the tasks and prune them down to a sensible
/// display set.
List<_PrunedTaskNode> _pruneTasks(List<TaskNode> fullTree,
    List<TaskBlueprint> available, List<TaskBlueprint> completed,
    [_PrunedTaskNode parent]) {
  // First build up the full tree with correct display state.
  List<_PrunedTaskNode> prePruned = [];
  for (final node in fullTree) {
    final blue = node.blueprint;
    final prunedTaskNode = _PrunedTaskNode(
        blueprint: blue,
        display: available.contains(blue)
            ? TaskDisplayState.available
            : completed.contains(blue)
                ? TaskDisplayState.complete
                : TaskDisplayState.locked);
    prunedTaskNode.children =
        _pruneTasks(node.children, available, completed, prunedTaskNode);
    prePruned.add(prunedTaskNode);
  }

  if (parent == null) {
    // top level, do the actual pruning.
    List<_PrunedTaskNode> pruned = [];
    for (final node in prePruned) {
      node.findTopLevelAvailable(pruned);
    }
    //remove levels that do not have available parents
    List<_PrunedTaskNode> healthy = [];
    for (final node in pruned) {
      if (!node.pruneDeadBranches()) {
        healthy.add(node);
      }
    }

    return healthy;
    //return pruned;
  }
  return prePruned;
  // Find nodes with available children.
  //return prePruned.where((node) => !node.shouldPrune(parent)).toList();
}

/// Build the list of slivers to display in each milestone section.
List<TaskPickerTask> _buildTaskPickerSlivers(List<TaskNode> fullTree,
    List<TaskBlueprint> available, List<TaskBlueprint> completed) {
  return flattenTree(_pruneTasks(fullTree, available, completed))
      .map((flatTreeItem) {
    final node = flatTreeItem.data as _PrunedTaskNode;
    return TaskPickerTask(
        blueprint: node.blueprint,
        display: node.display,
        lines: flatTreeItem.lines,
        hasNextSibling: flatTreeItem.hasNextSibling,
        hasNextChild: flatTreeItem.hasNextChild);
  }).toList();
}

/// Displays a list of the currently available [TaskBlueprint]s.
class ProjectPickerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskPool = Provider.of<TaskPool>(context);
    final _tasks = taskPool.availableTasks.toList(growable: false)
      ..sort((a, b) => -a.priority.compareTo(b.priority));
    final completed = (taskPool.completedTasks + taskPool.archivedTasks)
        .map((task) => task.blueprint)
        .toList();

    // Prune, flatten, and build up the linear array task list.
    final alpha =
        _buildTaskPickerSlivers(taskPool.alpha.tasks, _tasks, completed);
    final beta =
        _buildTaskPickerSlivers(taskPool.beta.tasks, _tasks, completed);
    final v1 = _buildTaskPickerSlivers(taskPool.v1.tasks, _tasks, completed);
// print("AVAILABLE $_tasks ${_tasks.length}");
// for(final task in _tasks)
// {
// 	print("${task.name}");
// }
    //print("FLAT ${flatTree.length} $completed");
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
          return alpha[index];
        }, childCount: alpha.length),
      ),
      SliverPersistentHeader(
        pinned: false,
        delegate: const TaskPickerHeader("Beta"),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return beta[index];
        }, childCount: beta.length),
      ),
      SliverPersistentHeader(
        pinned: false,
        delegate: const TaskPickerHeader("Version 1.0", showLine: false),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return v1[index];
        }, childCount: v1.length),
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
  }
}
