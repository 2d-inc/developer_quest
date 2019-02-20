import 'package:dev_rpg/src/shared_state/game/blocking_issue.dart';
import 'package:meta/meta.dart';

/// A blueprint of a task.
///
/// This class is immutable. Put runtime state into [Task].
@immutable
class TaskBlueprint {
  final String name;

  final int xpReward;

  final BlockingIssue blockingIssue;

  const TaskBlueprint(this.name, this.xpReward, this.blockingIssue);
}
