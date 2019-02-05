/// A single task for the player and her team to complete.
class Quest {
  final String name;

  int _percentComplete = 0;

  /// The quest has changed since the last time [update] was called.
  bool _isDirty = false;

  Quest(this.name);

  double get percentComplete => _percentComplete / 100;

  void makeProgress(int percent) {
    assert(percent >= 0);
    if (percent == 0) return;
    if (_percentComplete == 100) return;
    _percentComplete += percent;
    if (_percentComplete > 100) _percentComplete = 100;
    _isDirty = true;
  }

  bool update() {
    var wasDirty = _isDirty;
    _isDirty = false;
    return wasDirty;
  }
}
