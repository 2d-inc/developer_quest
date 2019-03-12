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
  final TaskBlueprint blueprint;
  TaskState _state = TaskState.working;
  TaskState get state => _state;

  Task(this.blueprint) : super(blueprint.name, blueprint.difficulty);

  @override
  void onCompleted() {
    _state = TaskState.completed;

    get<TaskPool>().completeTask(this);
    super.onCompleted();
  }

  void shipFeature() {
    assert(_state == TaskState.completed);
    _state = TaskState.rewarded;
    markDirty();

    get<World>().shipFeature(this);
    get<TaskPool>().archiveTask(this);
  }
}
