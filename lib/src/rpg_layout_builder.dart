import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

/// Layout for the dev_rpg game.
enum RpgLayout { slim, wide, ultrawide }

/// Signature for a function that builds a widget given an [RpgLayout].
///
/// Used by [RpgLayoutBuilder.builder].
typedef RpgLayoutWidgetBuilder = Widget Function(
    BuildContext context, RpgLayout layout);

/// Builds a widget tree that can depend on the parent widget's width
class RpgLayoutBuilder extends StatelessWidget {
  const RpgLayoutBuilder({
    @required this.builder,
    Key key,
  })  : assert(builder != null),
        super(key: key);

  /// Builds the widgets below this widget given this widget's layout width.
  final RpgLayoutWidgetBuilder builder;

  Widget _build(BuildContext context, BoxConstraints constraints) {
    var mediaWidth = MediaQuery.of(context).size.width;
    final RpgLayout layout = mediaWidth >= ultraWideLayoutThreshold
        ? RpgLayout.ultrawide
        : mediaWidth > wideLayoutThreshold ? RpgLayout.wide : RpgLayout.slim;
    return builder(context, layout);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }
}
