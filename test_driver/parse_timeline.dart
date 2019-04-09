import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart'
    show Timeline, TimelineSummary;

Future<int> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart tool/parse_timeline.dart [FILE]');
    return 2;
  }

  print("Running on file: ${args.single}");

  var file = File(args.single);
  var contents = await file.readAsString();
  var map = json.decode(contents) as Map<String, Object>;
  var timeline = Timeline.fromJson(map);
  var summary = TimelineSummary.summarize(timeline);

  var results = parse(timeline, summary);

  print('RunExpiredTasks events: ${results.expiredTasksEvents}');
  print('RunExpiredTasks duration: ${results.expiredTasksDuration}');

  print('Dart thread events: ${results.dartPhaseEvents}');
  print('Dart thread duration: ${results.dartPhaseDuration}');

  var lengthMicros = timeline.json['timeExtentMicros'] as int;
  var lengthSeconds = lengthMicros / Duration.microsecondsPerSecond;
  var frames = summary.countFrames();
  var fps = frames / lengthSeconds;

  print('Length: ${lengthSeconds}s');
  print('Frames: $frames');
  print('Average FPS: $fps');

  print('Dart percentage: ${results.dartPercentage.toStringAsPrecision(5)}');

  return 0;
}

AdditionalResults parse(Timeline timeline, TimelineSummary summary) {
  var dartPhaseEvents = 0;
  var dartPhaseDuration = Duration.zero;
  int expiredTasksEvents = 0;
  var durationMicros = 0;
  // Previous events per each thread.
  Map<int, int> prevs = {};

  for (final ev in timeline.events) {
    if (ev.phase == 'X' && ev.category == 'Dart') {
      // Dart thread event with duration.
      dartPhaseEvents += 1;
      dartPhaseDuration += ev.threadDuration;
    }

    if (ev.name != 'MessageLoop::RunExpiredTasks') continue;

    var tid = ev.threadId;
    assert(tid != null);

    if (ev.phase == 'B') {
      if (prevs.containsKey(tid)) {
        // print("there is already an event on this same thread");
      }
      prevs[tid] = ev.timestampMicros;
      continue;
    }

    if (ev.phase == 'E') {
      if (!prevs.containsKey(tid)) {
        // print("ending tid $tid that has no beginning,"
        //     "ts: ${ev.timestampMicros}");
        continue;
      }
      durationMicros += ev.timestampMicros - prevs[tid];
      prevs.remove(tid);
      expiredTasksEvents++;
      continue;
    }

    assert(false);
  }

  var expiredTasksDuration = Duration(microseconds: durationMicros);

  var lengthMicros = timeline.json['timeExtentMicros'] as int;
  var lengthSeconds = lengthMicros / Duration.microsecondsPerSecond;
  var frames = summary.countFrames();
  var fps = frames / lengthSeconds;
  var dartPercentage = dartPhaseDuration.inMicroseconds / lengthMicros;

  return AdditionalResults(
    Duration(microseconds: lengthMicros),
    frames,
    fps,
    dartPhaseEvents,
    dartPhaseDuration,
    expiredTasksEvents,
    expiredTasksDuration,
    dartPercentage,
  );
}

class AdditionalResults {
  final int dartPhaseEvents;

  final Duration dartPhaseDuration;

  final int expiredTasksEvents;

  final Duration expiredTasksDuration;

  final Duration length;

  final int frames;

  final double fps;

  /// Percentage of thread time spent in Dart.
  final double dartPercentage;

  const AdditionalResults(
      this.length,
      this.frames,
      this.fps,
      this.dartPhaseEvents,
      this.dartPhaseDuration,
      this.expiredTasksEvents,
      this.expiredTasksDuration,
      this.dartPercentage);
}
