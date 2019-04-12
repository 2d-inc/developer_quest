import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Displays a game statistic with its name and value.
class StatBadge extends StatelessWidget {
  final String stat;
  final ValueListenable<String> listenable;

  const StatBadge(this.stat, this.listenable);

  static const _valueStyle = TextStyle(fontSize: 12.0, color: Colors.white);

  static const _nameStyle = TextStyle(fontSize: 10.0, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Text(stat, style: _nameStyle),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: ValueListenableBuilder(
              valueListenable: listenable,
              builder: (context, String value, child) => Text(
                    value,
                    style: _valueStyle,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
