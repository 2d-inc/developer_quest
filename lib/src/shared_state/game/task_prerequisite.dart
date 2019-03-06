import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';

/// A prerequisite that is always satisfied.
const Prerequisite none = _None();

/// A prerequisite that is satisfied when all of the [prerequisites]
/// are satisfied.
class AllOf implements Prerequisite {
  final List<Prerequisite> prerequisites;

  const AllOf(this.prerequisites);

  @override
  bool isSatisfiedIn(Iterable<Prerequisite> done) {
    for (final prerequisite in prerequisites) {
      if (!prerequisite.isSatisfiedIn(done)) return false;
    }
    return true;
  }
}

/// A prerequisite that is satisfied when any of the [prerequisites]
/// is satisfied.
class AnyOf implements Prerequisite {
  final List<Prerequisite> prerequisites;

  const AnyOf(this.prerequisites);

  @override
  bool isSatisfiedIn(Iterable<Prerequisite> done) {
    for (final prerequisite in prerequisites) {
      if (prerequisite.isSatisfiedIn(done)) return true;
    }
    return false;
  }
}

/// A prerequisite that is satisfied only if the [child] is _not_ satisfied.
///
/// Use this when you want two tasks to be mutually exclusive.
///
/// Because we can't construct two tasks that depend on each other, this
/// operator takes the [TaskBlueprint.name] instead of the
/// [TaskBlueprint] itself.
class Not implements Prerequisite {
  final String name;

  const Not(this.name);

  @override
  bool isSatisfiedIn(Iterable<Prerequisite> done) {
    for (final prerequisite in done) {
      if (prerequisite is! TaskBlueprint) {
        throw ArgumentError(
            'Not was used with non-TaskBlueprint argument: $prerequisite');
      }
      if ((prerequisite as TaskBlueprint).name == name) return false;
    }
    return true;
  }
}

/// An abstract class representing something that can be satisfied or not.
///
/// Implemented by operators ([AnyOf], [AllOf]) and by [TaskBlueprint].
abstract class Prerequisite {
  bool isSatisfiedIn(Iterable<Prerequisite> done);
}

/// A prerequisite that is always satisfied. Only the first tasks in the tree
/// should have this prerequisite.
class _None implements Prerequisite {
  const _None();

  @override
  bool isSatisfiedIn(Iterable<Prerequisite> done) => true;
}
