/// Convenience class for giving names to key identifiers.
class KeyCode {
  static final int escape = 0x100070029;
  static final int backspace = 0x10007002a;
}
/*import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class KeyboardListener extends StatelessWidget {
  const KeyboardListener({
    Key key,
    @required this.child,
    @required this.focusNode,
    this.onRawKey,
    this.onKeyUp,
    this.onKeyDown,
  })  : assert(child != null),
        assert(focusNode != null),
        assert(onRawKey != null || onKeyUp != null || onKeyDown != null),
        super(key: key);

  /// Called on all key events.
  final ValueChanged<RawKeyEvent> onRawKey;

  /// Called only on keyUp action.
  final ValueChanged<KeyCode> onKeyUp;

  /// Called only on keyDown action.
  final ValueChanged<KeyCode> onKeyDown;

  /// Controls whether this widget has keyboard focus.
  final FocusNode focusNode;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focusNode,
      child: child,
      onKey: (RawKeyEvent event) {
        KeyCode code = keyCodeFrom(event);
        if (event.runtimeType == RawKeyUpEvent && onKeyUp != null) {
          onKeyUp(code);
        } else if (event.runtimeType == RawKeyDownEvent && onKeyDown != null) {
          onKeyDown(code);
        }
        if (onRawKey != null) onRawKey(event);
      },
    );
  }
}
*/
