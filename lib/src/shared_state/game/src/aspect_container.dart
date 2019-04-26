import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';

/// A general class for [Aspect]s that contain other [Aspect]s
abstract class AspectContainer<T extends Aspect> extends Aspect {
  final List<T> children;
  AspectContainer() : children = [];
  bool _guardRemove = false;
  List<T> _queuedRemoval;

  // Whether or not this container gets marked dirty when a child is dirty.
  bool get inheritsDirt => false;

  @override
  void update() {
    // guard against changing the list while iterating it
    _guardRemove = true;
    for (final T child in children) {
      if (inheritsDirt && child.isDirty) {
        markDirty();
      }
      child.update();
    }
    _guardRemove = false;

    // Process any queued removals.
    if (_queuedRemoval != null) {
      _queuedRemoval.forEach(children.remove);
      _queuedRemoval = null;
      markDirty();
    }

    super.update();
  }

  void addAspects(Iterable<T> aspects) => aspects.forEach(addAspect);
  void clearAspects() {
    _queuedRemoval?.clear();
    children.clear();
  }

  void setAspects(Iterable<T> aspects) {
    clearAspects();
    addAspects(aspects);
  }

  void addAspect(T aspect) {
    children.add(aspect);
    if (aspect is ChildAspect) {
      (aspect as ChildAspect).parent = this;
    }
    markDirty();
  }

  void removeAspect(T aspect) {
    // If we attempt to remove an aspect while the list is being iterated,
    // queue the removal and process it on our next update.
    if (_guardRemove) {
      _queuedRemoval ??= [];
      _queuedRemoval.add(aspect);
      return;
    }
    children.remove(aspect);
    markDirty();
  }
}
