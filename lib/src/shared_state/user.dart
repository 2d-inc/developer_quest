import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  final String name = "John Doe";

  @override
  String toString() => name;
}
