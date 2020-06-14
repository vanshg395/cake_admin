import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/http_exception.dart';

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

  Future<void> login(Map<String, String> data) async {
    try {
      final url = baseUrl + 'api/core/login/admin/';
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body);
        _username = data['username'];
        _token = 'Token ' + resBody['token'];
        final prefs = await SharedPreferences.getInstance();
        final _prefsData = json.encode({
          'token': _token,
          'username': _username,
        });
        await prefs.setString('userData', _prefsData);
      } else if (response.statusCode == 403) {
        throw HttpException('Not an Admin');
      } else if (response.statusCode == 400) {
        throw HttpException('Invalid Details');
      } else {
        throw HttpException('Internal Server Error');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      _token = extractedUserData['token'];
      _username = extractedUserData['username'];
      return true;
    } catch (e) {}
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
