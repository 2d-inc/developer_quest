import 'package:dev_rpg/src/rpg_layout_builder.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';
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
  @override
  void initState() {
    super.initState();
    demo.addListener(_demoModeChanged);
  }

  void _demoModeChanged() {
    var world = Provider.of<World>(context);
    switch (demo.value) {
      case DemoModeAction.showWelcomeScreen:
        world.reset();
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
        for (final task in world.taskPool.completedTasks) {
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
        Navigator.popUntil(context, (route) {
          return route.settings.name == '/gameloop';
        });
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    demo.removeListener(_demoModeChanged);
  }

  @override
  Widget build(BuildContext context) {
    return RpgLayoutBuilder(
      builder: (context, layout) =>
          layout == RpgLayout.wide ? GameScreenWide() : GameScreenSlim(),
    );
  }
}
