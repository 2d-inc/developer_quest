import 'dart:collection';

import 'package:dev_rpg/src/shared_state/game/project.dart';
import 'package:dev_rpg/src/shared_state/game/project_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';

/// A list of [Project]s. It represents the problems that need to be solved
/// before the game (mission) is successfully finished.
///
/// There is only one of this per world.
///
/// This is better that `List<Task>` because we can attach behavior
/// to this (like [update]) and only update the widgets once.
class ProjectPool extends Aspect {
  // All the projects in the system.
  static const List<ProjectBlueprint> availableProjects = const [
    ProjectBlueprint("Hello World", 100, [
      TaskBlueprint("Compile project", {Skill.Coding: 110}),
      TaskBlueprint("Add print statement", {Skill.Coding: 110}),
      TaskBlueprint("Tweet about coding prowess", {Skill.Coding: 110}),
    ]),
    ProjectBlueprint("Address Book", 220, [
      TaskBlueprint("Design app states", {Skill.Design: 130}),
      TaskBlueprint("Implement interface", {Skill.Coding: 130}),
    ]),
    ProjectBlueprint("Weather App", 400, [
      TaskBlueprint(
          "Plan features", {Skill.UX: 110, Skill.ProjectManagement: 110}),
      TaskBlueprint("Wireframe experience", {Skill.UX: 110}),
      TaskBlueprint("Design weather vignettes", {Skill.Design: 130}),
      TaskBlueprint(
          "Design app states", {Skill.Design: 110, Skill.ProjectManagement: 110}),
      TaskBlueprint("Build client model", {Skill.Coding: 110}),
      TaskBlueprint("Implement interface", {Skill.Coding: 130}),
      TaskBlueprint("Submit to store", {Skill.ProjectManagement: 110}),
    ])
  ];

  // The projects the player has chosen to add to their game.
  final List<Project> chosenProjects = [];
  // The projects that need to or are being worked on.
  final List<Project> workingProjects = [];
  // The projects that are donezo.
  final List<Project> deadProjects = [];

  ProjectPool();

  // Gets a flat list of projects interleaved with tasks belonging to that project.
  // Use this for an easy (albeit hacky) way to make a hierarchical ListView.
  List<Aspect> get flatWorkingProjectsWithTasks {
    List<Aspect> flattened = [];
    chosenProjects.forEach((Project project) {
      flattened.add(project);
      if (project.state == ProjectState.Started) {
        project.tasks.forEach((Task task) {
          flattened.add(task);
        });
      }
    });

    return flattened;
  }

  void update() {
    final List<Project> justCompleted = [];
    for (final project in workingProjects) {
      project.update();
	  if(project.state == ProjectState.Completed)
	  {
		  project.bonusXp = (project.ticksRemaining/10).round();
	  }
      if (project.state != ProjectState.Started) {
        justCompleted.add(project);
      }
    }

    if (justCompleted.isNotEmpty) {
      for (final justCompletedProject in justCompleted) {
        workingProjects.remove(justCompletedProject);
        deadProjects.add(justCompletedProject);
      }
      markDirty();
    }

    super.update();
  }

  void startProject(ProjectBlueprint projectBlueprint) {
    Project project = Project(projectBlueprint);
    chosenProjects.add(project);
    workingProjects.add(project);
    markDirty();
  }
}
