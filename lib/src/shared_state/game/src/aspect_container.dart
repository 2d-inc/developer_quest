import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';

/// A general class for [Aspect]s that contain other [Aspect]s
abstract class AspectContainer extends Aspect {
  final List<Aspect> children;
  AspectContainer() : children = [];
  bool _guardRemove = false;
  List<Aspect> _queuedRemoval;

  // Whether or not this container gets marked dirty when a child is dirty.
  bool get inheritsDirt => false;

  @override
  update() {
    // guard against changing the list while iterating it
    _guardRemove = true;
    for (Aspect child in children) {
      if (inheritsDirt && child.isDirty) {
        markDirty();
      }
      child.update();
    }
    _guardRemove = false;

    // Process any queued removals.
    if (_queuedRemoval != null) {
      for (final Aspect aspect in _queuedRemoval) {
        children.remove(aspect);
      }
      _queuedRemoval = null;
      markDirty();
    }

    super.update();
  }

  void addAspects(List<Aspect> aspects) {
    for (Aspect aspect in aspects) {
      addAspect(aspect);
    }
  }

  void addAspect(Aspect aspect) {
    children.add(aspect);
    if (aspect is ChildAspect) {
      (aspect as ChildAspect).parent = this;
    }
    markDirty();
  }

  void removeAspect(Aspect aspect) {
    // If we attempt to remove an aspect while the list is being iterated,
    // queue the removal and process it on our next update.
    if (_guardRemove) {
      if (_queuedRemoval == null) {
        _queuedRemoval = [];
      }
      _queuedRemoval.add(aspect);
      return;
    }
    children.remove(aspect);
    markDirty();
  }
}
