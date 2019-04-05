import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/company.dart';
import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';

/// The state of the game world.
///
/// Widgets should subscribe to aspects of the world (such as [projectPool])
/// instead of this whole world, unless they care about the most high-level
/// stuff (like whether the simulation is running).
class World extends AspectContainer {
  static const Duration newFeatureJoyDuration = Duration(seconds: 5);

  static Duration tickDuration = const Duration(milliseconds: 200);

  Timer _timer;

  final NpcPool npcPool;

  final TaskPool taskPool;

  final Company company;

  bool _isRunning = false;

  World()
      : npcPool = NpcPool(),
        taskPool = TaskPool(),
        company = Company() {
    addAspect(npcPool);
    addAspect(taskPool);
    addAspect(company);
  }

  /// Returns `true` when the simulation is currently running.
  bool get isRunning => _isRunning;

  void pause() {
    _timer.cancel();
    _isRunning = false;
    markDirty();
  }

  void start() {
    _timer = Timer.periodic(tickDuration, _performTick);
    _isRunning = true;
    markDirty();
  }

  void _performTick(Timer timer) {
    update();
  }

  /// TODO: Feature joy should probably depend on the feature
  ///       (might be another stat for the feature/task).
  static const double featureJoy = 5.0;

  void shipFeature(Task task) {
    // Todo: modify these values by how quickly the user completed the task
    // some bonus system?

    // Give some joy for the new feature, at least for a while.
    company.joy.number += featureJoy;

    Timer(newFeatureJoyDuration, () {
      company.joy.number -= featureJoy;
    });

    company.award(task.blueprint.userReward, task.blueprint.coinReward);
  }

  void shutdown() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }
}
