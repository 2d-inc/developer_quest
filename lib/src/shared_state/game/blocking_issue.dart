import 'package:meta/meta.dart';

/// Definition of a blocking issue that should appear sometime during
/// work on a task.
@immutable
class BlockingIssue {
  final Duration duration;

  /// The question to be presented to the player when they try
  /// to solve the issue.
  final String question;

  /// The percentage of task completion at which this blocking issue should
  /// appear.
  final int startsAtProgressLevel;

  const BlockingIssue(this.duration, this.question, this.startsAtProgressLevel);

  @Deprecated('Please create blocking issues that differ')
  BlockingIssue.sample()
      : this(Duration(seconds: 6), "Lorem ipsum question to be answered?", 25);
}
