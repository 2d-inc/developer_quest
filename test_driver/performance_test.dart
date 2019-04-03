import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:t_stats/t_stats.dart';

Future<void> main() async {
  FlutterDriver driver;

  try {
    driver = await FlutterDriver.connect();
    await _run(driver);
  } finally {
    if (driver != null) {
      await driver.close();
    }
  }
}

final _addTaskButtonFinder = find.byValueKey('add_task');

final _startGameFinder = find.byValueKey('start_game');

final _teamPickOkButtonFinder = find.byValueKey('team_pick_ok');

Future _completeTask(FlutterDriver driver, String taskName) async {
  await driver.waitFor(_addTaskButtonFinder);
  await driver.tap(_addTaskButtonFinder);

  var taskBlueprint = find.text(taskName);
  await driver.waitFor(taskBlueprint);
  await driver.tap(taskBlueprint);

  var task = find.byType('TaskListItem');
  await driver.waitFor(task);
  await driver.tap(find.text(taskName));

  var refactorer = find.text('The Refactorer');
  await driver.waitFor(refactorer);
  await driver.tap(refactorer);

  await driver.tap(_teamPickOkButtonFinder);

  var shipIt = find.text('Ship it!!');
  await driver.waitFor(shipIt);
  await driver.tap(shipIt);
}

Future<void> _run(FlutterDriver driver) async {
  var health = await driver.checkHealth();
  if (health.status != HealthStatus.ok) {
    throw StateError('FlutterDriver health: $health');
  }

  await driver.tap(_startGameFinder);
  await driver.waitForAbsent(_startGameFinder);
  await driver.tap(find.text("Tasks"));

  // Give the UI time to settle down before starting the trace.
  await Future<void>.delayed(const Duration(milliseconds: 300));

  await driver.startTracing();

  await _completeTask(driver, 'Prototype');
  await _completeTask(driver, 'Basic Backend');

  var timeline = await driver.stopTracingAndDownloadTimeline();

  var now = DateTime.now();
  var name = 'walkthrough-${now.toIso8601String()}';
  var filename = name.replaceAll(':', '-');

  var summary = TimelineSummary.summarize(timeline);
  await summary.writeSummaryToFile(filename, pretty: true);
  await summary.writeTimelineToFile(filename);

  var stat = Statistic.from(
    summary.summaryJson['frame_build_times'] as List<int>,
    name: name,
  );
  var tsv = File('test_driver/perf_stats.tsv').openWrite(mode: FileMode.append);
  // Add general build time statistics.
  tsv.write(stat.toTSV());
  // Add additional useful stats from the TimelineSummary.
  tsv.write('\t');
  tsv.write(summary.computePercentileFrameBuildTimeMillis(90.0));
  tsv.write('\t');
  tsv.write(summary.computePercentileFrameBuildTimeMillis(99.0));
  tsv.write('\t');
  tsv.write(summary.computeWorstFrameBuildTimeMillis());
  tsv.write('\t');
  tsv.write(summary.computeMissedFrameBuildBudgetCount());
  tsv.writeln();
  await tsv.close();
  print(stat);
}
