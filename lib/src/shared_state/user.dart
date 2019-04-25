import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  final String name = 'Daring Developer';

  @override
  String toString() => name;
}
