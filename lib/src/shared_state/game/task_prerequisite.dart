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
      if (prerequisite.isSatisfiedIn(done)) return true;
    }
    return false;
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
      if (!prerequisite.isSatisfiedIn(done)) return false;
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
