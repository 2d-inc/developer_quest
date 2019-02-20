import 'package:flutter/foundation.dart';

/// An aspect of the game world that can be listened to.
abstract class Aspect extends ChangeNotifier {
  bool _dirty = false;

  /// The aspect has changed since the last time [update] was called.
  bool get isDirty => _dirty;

  /// Marks the aspect dirty (changed).
  ///
  /// This can be called from outside the class (unlike [notifyListeners], which
  /// is [protected]). Also unlike [notifyListeners], this does not immediately
  /// notify. Listeners will be called on next call of [update].
  void markDirty() {
    _dirty = true;
  }

  /// Called every "logical frame" (physical update in game parlance), to update
  /// the state of this aspect.
  ///
  /// Subclasses must call `super.update()`.
  @mustCallSuper
  void update() {
    if (_dirty) {
      notifyListeners();
      _dirty = false;
    }
  }
}
