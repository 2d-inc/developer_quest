import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';

/// A list of [Task]s. It represents the problems that need to be solved
/// before the game (mission) is successfully finished.
///
/// There is only one of this per world.
///
/// This is better that `List<Task>` because we can attach behavior
/// to this (like [update]) and only update the widgets once.
class TaskPool extends Aspect {
  // All the projects in the system.
  static const List<TaskBlueprint> availableProjects = const [
    TaskBlueprint("Compile project", {Skill.Coding: 110}),
    TaskBlueprint("Add print statement", {Skill.Coding: 110}),
    TaskBlueprint("Tweet about coding prowess", {Skill.Coding: 110}),
    TaskBlueprint("Design app states", {Skill.Design: 130}),
    TaskBlueprint("Implement interface", {Skill.Coding: 130}),
    TaskBlueprint(
        "Plan features", {Skill.UX: 110, Skill.ProjectManagement: 110}),
    TaskBlueprint("Wireframe experience", {Skill.UX: 110}),
    TaskBlueprint("Design weather vignettes", {Skill.Design: 130}),
    TaskBlueprint(
        "Design app states", {Skill.Design: 110, Skill.ProjectManagement: 110}),
    TaskBlueprint("Build client model", {Skill.Coding: 110}),
    TaskBlueprint("Implement interface", {Skill.Coding: 130}),
    TaskBlueprint("Submit to store", {Skill.ProjectManagement: 110}),
  ];

  // The projects that need to or are being worked on.
  final List<Task> workingTasks = [];

  // The projects that are done.
  final List<Task> deadTasks = [];

  TaskPool();

  void update() {
    final List<Task> justCompleted = [];
    for (final task in workingTasks) {
      task.update();
      if (task.isComplete) {
        // TODO: update stats (add happiness, growth, etc.)
        justCompleted.add(task);
      }
    }

    if (justCompleted.isNotEmpty) {
      markDirty();
    }

    for (final task in justCompleted) {
      workingTasks.remove(task);
      deadTasks.add(task);
    }

    super.update();
  }

  void startTask(TaskBlueprint projectBlueprint) {
    Task task = Task(projectBlueprint);
    workingTasks.add(task);
    markDirty();
  }
}
