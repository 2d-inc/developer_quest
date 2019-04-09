import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart'
    show Timeline, TimelineSummary;

Future<int> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart tool/parse_timeline.dart [FILE]');
    return 2;
  }

  var file = File(args.single);
  var contents = await file.readAsString();
  var map = json.decode(contents) as Map<String, Object>;
  var timeline = Timeline.fromJson(map);

  var durationMicros = 0;
  // Previous events per each thread.
  Map<int, int> prevs = {};
  for (final ev in timeline.events) {
    if (ev.name != 'MessageLoop::RunExpiredTasks') continue;

    var tid = ev.threadId;
    assert(tid != null);

    if (ev.phase == 'B') {
      assert(!prevs.containsKey(tid));
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
      continue;
    }

    assert(false);
  }

  var duration = Duration(microseconds: durationMicros);
  print('RunExpiredTasks duration: $duration');

  var threadDuration = timeline.events
      .where((ev) => ev.phase == 'X' && ev.category == 'Dart')
      .fold<Duration>(Duration.zero, (prev, e) => prev + e.threadDuration);

  print('Thread duration: $threadDuration');

  var summary = TimelineSummary.summarize(timeline);
  var lengthMicros = timeline.json['timeExtentMicros'] as int;
  var lengthSeconds = lengthMicros / Duration.microsecondsPerSecond;
  var frames = summary.countFrames();
  var fps = frames / lengthSeconds;

  print('Length: ${lengthSeconds}s');
  print('Frames: $frames');
  print('Average FPS: $fps');

  return 0;
}
