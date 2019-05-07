import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart'
    show Timeline, TimelineSummary;
import 'package:logging/logging.dart';
import 'package:t_stats/t_stats.dart';

Future<int> main(List<String> args) async {
  // Set [loggingLevel] below to change verboseness of the tool.
  Logger.root.level = loggingLevel;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('[${rec.level.name}] ${rec.message}');
  });

  if (args.length != 1) {
    stderr.writeln('Usage: dart test_driver/parse_timeline.dart [FILE]');
    return 2;
  }

  log.info('Running on file: ${args.single}');

  var file = File(args.single);
  var contents = await file.readAsString();
  var map = json.decode(contents) as Map<String, Object>;
  var timeline = Timeline.fromJson(map);
  var summary = TimelineSummary.summarize(timeline);

  var results = parse(timeline, summary);

  log.info('RunExpiredTasks events: ${results.expiredTasksEvents}');
  log.info('RunExpiredTasks duration: ${results.expiredTasksDuration}');

  log.info('Dart thread events: ${results.dartPhaseEvents}');
  log.info('Dart thread duration: ${results.dartPhaseDuration}');

  var lengthMicros = timeline.json['timeExtentMicros'] as int;
  var lengthSeconds = lengthMicros / Duration.microsecondsPerSecond;
  var frames = summary.countFrames();
  var fps = frames / lengthSeconds;

  log.info('Length: ${lengthSeconds}s');
  log.info('Frames: $frames');
  log.info('Average FPS: $fps');

  var frameRequestStats = Statistic.from(
      results.frameRequestDurations.map((d) => d.inMicroseconds));
  log.info('Frame Request durations: ${frameRequestStats.toString()}');

  log.info('Dart percentage: ${results.dartPercentage.toStringAsPrecision(5)}');

  return 0;
}

/// The level at which log messages are printed to the console.
///
/// If you want to see more messages being logged, set this accordingly
/// (e.g. to [Level.ALL]).
const Level loggingLevel = Level.INFO;

/// A logger of parsing events.
final Logger log = Logger('parse_timeline');

AdditionalResults parse(Timeline timeline, TimelineSummary summary) {
  var dartPhaseEvents = 0;
  var dartPhaseDuration = Duration.zero;
  int expiredTasksEvents = 0;
  var durationMicros = 0;
  // Previous events per each thread.
  Map<int, int> prevs = {};
  String prevFrameRequestId;
  int prevFrameRequestStart;
  final frameRequestDurations = <Duration>[];

  for (final ev in timeline.events) {
    if (ev.phase == 'X' && ev.category == 'Dart') {
      // Dart thread event with duration.
      dartPhaseEvents += 1;
      dartPhaseDuration += ev.duration;
    }

    if (ev.name == 'MessageLoop::FlushTasks') {
      var tid = ev.threadId;
      assert(tid != null);

      if (ev.phase == 'B') {
        if (prevs.containsKey(tid)) {
          log.fine(
              'There is already an event that started on this same thread. '
              'Ignoring the previous start. tid=$tid, ev=$ev');
        }
        prevs[tid] = ev.timestampMicros;
        continue;
      }

      if (ev.phase == 'E') {
        if (!prevs.containsKey(tid)) {
          log.fine(
              'Encountered end to an event that has no beginning (at least '
              'not in our part of the timeline). Ignoring. tid=$tid, ev=$ev');
          continue;
        }
        durationMicros += ev.timestampMicros - prevs[tid];
        prevs.remove(tid);
        expiredTasksEvents++;
        continue;
      }
    }

    if (ev.name == 'Frame Request Pending') {
      var tid = ev.threadId;
      assert(tid != null);

      if (ev.phase == 'b') {
        if (prevFrameRequestId != null || prevFrameRequestStart != null) {
          log.info('There is already a frame request that started. '
              'Ignoring the previous start. id=$prevFrameRequestId, ev=$ev');
        }
        prevFrameRequestId = ev.json['id'] as String;
        prevFrameRequestStart = ev.timestampMicros;
        continue;
      }

      if (ev.phase == 'e') {
        if (prevFrameRequestId == null || prevFrameRequestStart == null) {
          log.fine('Encountered end to a frame request that has no beginning '
              '(at least not in our part of the timeline). Ignoring. ev=$ev');
          continue;
        }
        var id = ev.json['id'] as String;
        if (id != prevFrameRequestId) {
          log.warning('Frame-request id=$id does not match the one that '
              'we are tracking id$prevFrameRequestId. Ignoring. ev=$ev');
          continue;
        }
        var frameRequestDuration =
            Duration(microseconds: ev.timestampMicros - prevFrameRequestStart);
        frameRequestDurations.add(frameRequestDuration);
        prevFrameRequestId = null;
        prevFrameRequestStart = null;
        continue;
      }
    }
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
    frameRequestDurations,
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

  /// These are durations of all recorded `Frame Request Pending` events.
  ///
  /// In general, longer durations are a good indicator of jank.
  final List<Duration> frameRequestDurations;

  final int frames;

  /// This is just the number of "Frame" events per the whole duration
  /// of the [Timeline]. So, for example, a totally static app can easily
  /// have fractional [fps].
  ///
  /// For a more reliable source of jank info, look at [frameRequestDurations].
  final double fps;

  /// Percentage of CPU time spent in Dart.
  final double dartPercentage;

  const AdditionalResults(
      this.length,
      this.frames,
      this.fps,
      this.frameRequestDurations,
      this.dartPhaseEvents,
      this.dartPhaseDuration,
      this.expiredTasksEvents,
      this.expiredTasksDuration,
      this.dartPercentage);
}
