import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays a game statistic with its name and value.
class StatBadge<T> extends StatelessWidget {
  final String stat;
  final T value;

  StatBadge(this.stat, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Text(
              stat,
              style: TextStyle(fontSize: 10.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Text(NumberFormat.compact().format(value),
                style: TextStyle(fontSize: 12.0, color: Colors.white)),
          )
        ]));
  }
}
