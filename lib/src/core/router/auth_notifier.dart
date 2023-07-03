import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';


class AuthNotifier extends ChangeNotifier {

  User? _user;

  bool get isAuthenticated => _user != null;

  AuthNotifier (FirebaseAuth firebaseAuth) {
    firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
}