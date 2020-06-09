import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String _token;
  String _username;

  String get token {
    return _token;
  }

  String get username {
    return _username;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> login() async {}
}
