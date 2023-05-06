import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  dynamic _token = null;
  DateTime _expireyDate = DateTime.now();
  dynamic _userId = null;
  dynamic autoTimer;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  dynamic get token {
    if (_expireyDate != null &&
        _expireyDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  //sign Up method
  Future<void> signUp(String email, String password) async {
    // final url = 'https://reqres.in/api/register';
    try {
     final response = await http.post(Uri.parse('https://reqres.in/api/register'),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
      final extractedResponse = json.decode(response.body);
      print(
          "${extractedResponse.body}..................................................");
      // if (extractedResponse['error'] != null) {
      //   throw HttpException(extractedResponse['error']);
      // }
      _token = extractedResponse['token'];
      print('asfdfsdfadsffffffffffffffffffffffff $_token');
      _userId = extractedResponse['id'];
      _expireyDate = DateTime.now().add(
        Duration(seconds: 300),
      );

      autoLogOuttimerset();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expireyDate': _expireyDate.toIso8601String(),
        },
      );
      print(response.body);
    } catch (error) {
      throw error;
    }
  }

  //sign in handler
  Future<void> signIn(String email, String password) async {
    final url = 'https://reqres.in/api/register';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      final extractedResponse = json.decode(response.body);
      if (extractedResponse['error'] != null) {
        throw HttpException(extractedResponse['error']);
      }
      _token = extractedResponse['token'];
      _expireyDate = DateTime.now().add(
        Duration(seconds: 300),
      );

      autoLogOuttimerset();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expireyDate': _expireyDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      print(response.body);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireyDate = expiryDate;
    notifyListeners();
    autoLogOuttimerset();
    return true;
  }

  //log out handler
  void logOut() async {
    _expireyDate = null as DateTime;
    _token = null;
    _userId = null;
    if (autoTimer != null) {
      autoTimer.cancel();
      autoTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

//auto timer handler
  void autoLogOuttimerset() {
    if (autoTimer != null) {
      autoTimer.cancel();
    }
    final exactExpireTime = _expireyDate.difference(DateTime.now()).inSeconds;
    autoTimer = Timer(Duration(seconds: exactExpireTime), logOut);
  }
}
