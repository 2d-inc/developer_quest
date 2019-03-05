import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  final String name = "Daring Developer";
  int xp = 0;
  int coin = 0;
  
  @override
  String toString() => name;
}
