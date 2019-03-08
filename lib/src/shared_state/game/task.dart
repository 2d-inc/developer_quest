import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

enum TaskState { working, completed, rewarded }

/// A single task for the player and her team to complete.
///
/// The definition of the task is in [blueprint]. This class holds the runtime
/// state (like [percentComplete]).
class Task extends WorkItem {
  String get name => blueprint.name;
  final TaskBlueprint blueprint;
  TaskState _state = TaskState.working;
  TaskState get state => _state;
  Map<Skill, double> get difficulty => blueprint.difficulty;

  Task(this.blueprint);

  @override
  void onCompleted() {
    _state = TaskState.completed;

    get<TaskPool>().completeTask(this);
    super.onCompleted();
  }

  void shipFeature() {
    if (_state == TaskState.completed) {
      _state = TaskState.rewarded;
      markDirty();

      get<World>().shipFeature(this);
      get<TaskPool>().archiveTask(this);
    }
  }
}
