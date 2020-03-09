import 'dart:io';
import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:git/git.dart';
import 'package:t_stats/t_stats.dart';

import 'parse_timeline.dart';

Future<void> main(List<String> args) async {
  FlutterDriver driver;

  try {
    driver = await FlutterDriver.connect();
    var timeline = await _run(driver);
    await _save(timeline);
  } finally {
    if (driver != null) {
      await driver.close();
    }
  }
}

final _addTaskButtonFinder = find.byValueKey('add_task');

final _startGameFinder = find.byValueKey('start_game');

final _teamPickOkButtonFinder = find.byValueKey('team_pick_ok');

/// This is run with [FlutterDriver.runUnsynchronized].
Future _completeTask(FlutterDriver driver, String taskName) async {
  await driver.tap(_addTaskButtonFinder);

  var taskBlueprint = find.text(taskName);
  await driver.tap(taskBlueprint);

  var jack = find.byValueKey('jack');
  await driver.tap(jack);

  var sourcerer = find.byValueKey('sourcerer');
  await driver.tap(sourcerer);

  await driver.tap(_teamPickOkButtonFinder);

  var shipIt = find.text('LAUNCH!');
  await driver.waitFor(shipIt);
  await driver.tap(find.text(taskName));
}

Future<Timeline> _run(FlutterDriver driver) async {
  var health = await driver.checkHealth();
  if (health.status != HealthStatus.ok) {
    throw StateError('FlutterDriver health: $health');
  }

  // Need to run this unsynchronized as the idle (looping) animation for
  // the home screen is playing.
  await driver.runUnsynchronized(() async {
    // Wait for the game to settle first.
    await Future<void>.delayed(const Duration(seconds: 2));
    await driver.tap(_startGameFinder);

    // Hire the two founders.
    await driver.tap(find.byValueKey('hire-jack'));
    await driver.tap(find.text('HIRE'));
    await driver.tap(find.byValueKey('close-character-modal'));
    await driver.tap(find.byValueKey('hire-sourcerer'));
    await driver.tap(find.text('HIRE'));
    await driver.tap(find.byValueKey('close-character-modal'));

    await driver.tap(find.text('Tasks'));
  });

  // Give the UI time to settle down before starting the trace.
  await Future<void>.delayed(const Duration(seconds: 1));

  await driver.startTracing();

  await driver.runUnsynchronized(() async {
    await _completeTask(driver, 'Prototype');
    await _completeTask(driver, 'Basic UI');
    await _completeTask(driver, 'Basic Backend');
    await _completeTask(driver, 'Alpha release');
  });

  return driver.stopTracingAndDownloadTimeline();
}

Future<void> _save(Timeline timeline) async {
  var description = Platform.environment['DESC'];

  if (description == null) {
    stderr.writeln('[WARNING] No description of the run through provided. '
        'You can do so via the \$DESC shell variable. '
        'For example, run the command like this: \n\n'
        '\$> DESC="run with foo" '
        'flutter drive --target=test_driver/performance.dart --profile\n');
    description = '';
  }

  var gitSha = '';
  if (await GitDir.isGitDir('.')) {
    var gitDir = await GitDir.fromExisting('.');
    var branch = await gitDir.getCurrentBranch();
    gitSha = branch.sha.substring(0, 8);
  }

  var now = DateTime.now();
  var id = 'performance_test-${now.toIso8601String()}';
  var filename = id.replaceAll(':', '-');

  var summary = TimelineSummary.summarize(timeline);

  await summary.writeSummaryToFile(filename, pretty: true);
  await summary.writeTimelineToFile(filename);

  var rasterizerTimes =
      summary.summaryJson['frame_rasterizer_times'] as List<int>;
  var buildTimes = summary.summaryJson['frame_build_times'] as List<int>;
  var buildTimesStat = Statistic.from(
    buildTimes,
    name: id,
  );
  var additional = parse(timeline, summary);
  var frameRequestStats = Statistic.from(
      additional.frameRequestDurations.map((d) => d.inMicroseconds));

  IOSink stats;
  try {
    stats = File('test_driver/perf_stats.tsv').openWrite(mode: FileMode.append);
    // Add general build time statistics.
    stats.write(buildTimesStat.toTSV());
    // Add description.
    stats.write('\t');
    stats.write(description);
    // Add additional useful stats from the TimelineSummary.
    stats.write('\t');
    stats.write(summary.computePercentileFrameBuildTimeMillis(90));
    stats.write('\t');
    stats.write(summary.computePercentileFrameBuildTimeMillis(99));
    stats.write('\t');
    stats.write(summary.computeWorstFrameBuildTimeMillis());
    stats.write('\t');
    stats.write(summary.computeMissedFrameBuildBudgetCount());
    stats.write('\t');
    // Add things from parse_timeline.dart.
    stats.write(additional.length.inMicroseconds);
    stats.write('\t');
    stats.write(additional.frames);
    stats.write('\t');
    stats.write(additional.fps);
    stats.write('\t');
    stats.write(frameRequestStats.mean);
    stats.write('\t');
    stats.write(additional.dartPercentage);
    stats.write('\t');
    stats.write(additional.dartPhaseEvents);
    stats.write('\t');
    stats.write(additional.dartPhaseDuration.inMicroseconds);
    stats.write('\t');
    stats.write(additional.expiredTasksEvents);
    stats.write('\t');
    stats.write(additional.expiredTasksDuration.inMicroseconds);
    // Add timestamp.
    stats.write('\t');
    stats.write(now.toIso8601String());
    // End line.
    stats.writeln();
  } finally {
    await stats?.close();
  }

  IOSink durations;
  try {
    durations =
        File('test_driver/durations.tsv').openWrite(mode: FileMode.append);
    var length = [
      buildTimes.length,
      rasterizerTimes.length,
      additional.frameRequestDurations.length
    ].fold(0, max);
    for (int i = 0; i < length; i++) {
      var build = i < buildTimes.length ? buildTimes[i].toString() : '';
      var rasterizer =
          i < rasterizerTimes.length ? rasterizerTimes[i].toString() : '';
      var frameRequest = i < additional.frameRequestDurations.length
          ? additional.frameRequestDurations[i].inMicroseconds.toString()
          : '';
      var row = <String>[
        id,
        build,
        rasterizer,
        frameRequest,
        gitSha,
        description,
      ].join('\t');
      durations.writeln(row);
    }
  } finally {
    await durations?.close();
  }

  print(buildTimesStat);
}
