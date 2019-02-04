import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  final String name = "Jane Doe";

  @override
  String toString() => name;
}
