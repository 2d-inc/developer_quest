import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String name = "Daring Developer";
  FirebaseUser user;
  

  @override
  String toString() => name;
  
  signIn() async {
    user = await _auth.signInAnonymously();
  }
}
