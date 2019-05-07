import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/task_tree/task_tree.dart';
import 'package:dev_rpg/src/shared_state/game/task_tree/tree_hierarchy.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/task_picker/task_picker_header.dart';
import 'package:dev_rpg/src/widgets/task_picker/task_picker_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A pruned representation of the TaskNode. We use this to build up a tree of
/// tasks that makes sense given the current state of availability.
class _PrunedTaskNode implements TreeData {
  @override
  List<_PrunedTaskNode> children;
  final TaskDisplay display;
  final TaskBlueprint blueprint;

  _PrunedTaskNode({this.blueprint, this.display});

  /// Find the deepest level of the tree that has an available item in it.
  /// Add it to the available list.
  void findTopLevelAvailable(List<_PrunedTaskNode> available) {
    var hasAvailableChild =
        children.any((child) => child.display == TaskDisplay.available);
    if (hasAvailableChild || display == TaskDisplay.available) {
      available.add(this);
    } else {
      for (final child in children) {
        child.findTopLevelAvailable(available);
      }
    }
  }

  /// Remove branches that are completely dead (parent, self, and children
  /// are not available)
  bool pruneDeadBranches([_PrunedTaskNode parent]) {
    children.removeWhere((child) => child.pruneDeadBranches(this));
    return children.isEmpty &&
        display != TaskDisplay.available &&
        (parent == null || parent.display != TaskDisplay.available);
  }
}

/// Compute display data for the tasks and prune them down to a sensible
/// display set.
List<_PrunedTaskNode> _pruneTasks(List<TaskNode> fullTree,
    List<TaskBlueprint> available, List<TaskBlueprint> completed,
    [_PrunedTaskNode parent]) {
  // First build up the full tree with correct display state.
  var prePruned = <_PrunedTaskNode>[];
  for (final node in fullTree) {
    var blue = node.blueprint;
    var prunedTaskNode = _PrunedTaskNode(
        blueprint: blue,
        display: available.contains(blue)
            ? TaskDisplay.available
            : completed.contains(blue)
                ? TaskDisplay.complete
                : TaskDisplay.locked);
    prunedTaskNode.children =
        _pruneTasks(node.children, available, completed, prunedTaskNode);
    prePruned.add(prunedTaskNode);
  }

  // If you want to see the full tree, simply skip this conditional
  if (parent == null) {
    // top level, do the actual pruning.
    var pruned = <_PrunedTaskNode>[];
    for (final node in prePruned) {
      node.findTopLevelAvailable(pruned);
    }
    //remove levels that do not have available parents
    var healthy = <_PrunedTaskNode>[];
    for (final node in pruned) {
      if (!node.pruneDeadBranches()) {
        healthy.add(node);
      }
    }

    return healthy;
  }
  return prePruned;
}

/// Make a [TaskPickerItem], the widget that gets displayed in the task
/// selector, from the [FlattenedTreeData].
TaskPickerItem _makeTaskPickerTask(FlattenedTreeData flatTreeItem) {
  var node = flatTreeItem.data as _PrunedTaskNode;
  return TaskPickerItem(
      blueprint: node.blueprint,
      display: node.display,
      lines: flatTreeItem.lines,
      hasNextSibling: flatTreeItem.hasNextSibling,
      hasNextChild: flatTreeItem.hasNextChild);
}

/// Build the list of slivers to display in each milestone section.
List<TaskPickerItem> _buildTaskPickerSlivers(List<TaskNode> fullTree,
    List<TaskBlueprint> available, List<TaskBlueprint> completed) {
  return flattenTree(_pruneTasks(fullTree, available, completed))
      .map(_makeTaskPickerTask)
      .toList();
}

/// Displays a list of the currently available [TaskBlueprint]s.
class ProjectPickerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskPool = Provider.of<TaskPool>(context);
    var _tasks = taskPool.availableTasks.toList(growable: false)
      ..sort((a, b) => -a.priority.compareTo(b.priority));
    var completed = (taskPool.completedTasks + taskPool.archivedTasks)
        .map((task) => task.blueprint)
        .toList();

    // Prune, flatten, and build up the linear array task list.
    var alpha =
        _buildTaskPickerSlivers(taskPool.alpha.tasks, _tasks, completed);
    var beta = _buildTaskPickerSlivers(taskPool.beta.tasks, _tasks, completed);
    var v1 = _buildTaskPickerSlivers(taskPool.v1.tasks, _tasks, completed);

    var slivers = <Widget>[
      SliverPadding(
        padding: const EdgeInsets.only(top: 15),
        sliver: SliverPersistentHeader(
          pinned: false,
          delegate: const TaskPickerHeader('Alpha'),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return alpha[index];
        }, childCount: alpha.length),
      ),
      SliverPersistentHeader(
        pinned: false,
        delegate: const TaskPickerHeader('Beta'),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return beta[index];
        }, childCount: beta.length),
      ),
      SliverPersistentHeader(
        pinned: false,
        delegate: TaskPickerHeader('Version 1.0', showLine: v1.isNotEmpty),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return v1[index];
        }, childCount: v1.length),
      ),
    ];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: modalMaxWidth),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: Container(
            color: modalBackgroundColor,
            child: CustomScrollView(slivers: slivers),
          ),
        ),
      ),
    );
  }
}
