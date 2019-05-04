import 'dart:async';

import 'package:dev_rpg/src/rpg_layout_builder.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:dev_rpg/src/widgets/restart_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'demo_mode.dart';
import 'game_screen/character_modal.dart';
import 'game_screen/project_picker_modal.dart';
import 'game_screen_slim.dart';
import 'game_screen_wide.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer _inactivityTimer;
  @override
  void initState() {
    super.initState();
    demo.addListener(_demoModeChanged);
  }

  void _scheduleInactivityTimer(BuildContext context) {
    _inactivityTimer?.cancel();
    _inactivityTimer =
        Timer(const Duration(seconds: 40), () => _inactivityDetected(context));
  }

  void _inactivityDetected(BuildContext context) {
    var world = Provider.of<World>(context);
    showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => RestartModal(world))
        .then((_) => _scheduleInactivityTimer(context));
  }

  void _demoModeChanged() {
    // Make sure modals are closed.
    if (demo.value != DemoModeAction.showWelcomeScreen) {
      Navigator.popUntil(context, (route) {
        return route.settings.name == '/gameloop';
      });
    }
    var world = Provider.of<World>(context);
    switch (demo.value) {
      case DemoModeAction.showWelcomeScreen:
        world.reset();
        world.pause();
        Navigator.popUntil(context, (route) {
          return route.settings.name == '/';
        });
        break;
      case DemoModeAction.showCharacterModal:
        // Hire any available character.
        for (final character in world.characterPool.children) {
          if (character.canUpgrade) {
            character.upgrade();
            break;
          }
        }
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return ChangeNotifierProvider<Character>.value(
                notifier: world.characterPool.random(),
                child: CharacterModal(),
              );
            });
        break;
      case DemoModeAction.showTasksScreen:
        // Take this opportunity to launch any completed tasks.
        var copy = world.taskPool.completedTasks.toList();
        for (final task in copy) {
          task.shipFeature();
        }
        break;
      case DemoModeAction.showTasksModal:
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return ChangeNotifierProvider<TaskPool>.value(
                notifier: world.taskPool,
                child: ProjectPickerModal(),
              );
            });
        break;
      case DemoModeAction.pickTask:
        if (world.taskPool.availableTasks.isNotEmpty) {
          var task = world.taskPool.availableTasks.first;
          world.taskPool.startTask(task);
          world.taskPool.workItems.first
              .assignTeam(world.characterPool.fullTeam);
        }
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        demo.cancel();
        _scheduleInactivityTimer(context);
      },
      child: RpgLayoutBuilder(
        builder: (context, layout) =>
            layout == RpgLayout.slim ? GameScreenSlim() : GameScreenWide(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _inactivityTimer?.cancel();
    demo.removeListener(_demoModeChanged);
  }
}
