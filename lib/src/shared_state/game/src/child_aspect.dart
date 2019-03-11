import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

/// A mixin that allows for hierarchical [Aspect]s
/// and also allows searching for specific parent [Aspect]s
mixin ChildAspect {
  Aspect parent;

  T get<T>() {
    Aspect looking = parent;
    while (looking != null) {
      if (looking is T) {
        return looking as T;
      }
      looking = looking is ChildAspect ? (looking as ChildAspect).parent : null;
    }

    return null;
  }
}
