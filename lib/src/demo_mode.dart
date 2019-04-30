import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DemoModeAction {
  showTeamScreen,
  showTasksScreen,
  showCharacterModal,
  pickTask,
  showTasksModal,
  showWelcomeScreen
}

/// Map of [DemoModeAction] to the frequency that they occur.
Map<DemoModeAction, int> demoActionFrequency = {
  DemoModeAction.showTeamScreen: 15,
  DemoModeAction.showTasksScreen: 15,
  DemoModeAction.showCharacterModal: 0,
  DemoModeAction.showTasksModal: 0,
  DemoModeAction.showWelcomeScreen: 1,
};

/// Build weighted list of demo actions. Put each [DemoModeAction] type in
/// the list n times, where n is the value in demoActionFrequency.
List<DemoModeAction> demoActionChances = demoActionFrequency.keys
    .expand(
        (action) => List.generate(demoActionFrequency[action], (_) => action))
    .toList();

class DemoMode extends ValueNotifier<DemoModeAction> {
  Timer _timer;

  DemoMode() : super(DemoModeAction.showWelcomeScreen);
  final Random randomizer = Random();

  void _pickNextAction() {
    if (value == DemoModeAction.showWelcomeScreen) {
      value = DemoModeAction.showTeamScreen;
    } else if (value == DemoModeAction.showTeamScreen) {
      value = DemoModeAction.showCharacterModal;
    } else if (value == DemoModeAction.showTasksScreen) {
      value = DemoModeAction.showTasksModal;
    } else if (value == DemoModeAction.showTasksModal) {
      value = DemoModeAction.pickTask;
    } else {
      value = demoActionChances[randomizer.nextInt(demoActionChances.length)];
    }
    notifyListeners();
    delay(seconds: 5);
  }

  void delay({bool indefinitely = false, int seconds = 25}) {
    _timer?.cancel();
    if (!indefinitely) {
      _timer = Timer(Duration(seconds: seconds), _pickNextAction);
    }
  }

  void cancel() {
    value = DemoModeAction.showWelcomeScreen;
    delay();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

DemoMode demo = DemoMode();
