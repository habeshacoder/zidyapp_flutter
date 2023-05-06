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

// void handlesignup(Map<String, >) async{
//   var client = http.Client();
// try {
//   var response = await client.post(
//       Uri.https('example.com', 'whatsit/create'),
//       body: {'name': 'doodle', 'color': 'blue'});
//   var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   var uri = Uri.parse(decodedResponse['uri'] as String);
//   print(await client.get(uri));
// } finally {
//   client.close();
// }
// }
  Future<void> signUpUser(Map<String, dynamic> signUpUserData) async {
    final url = 'https://reqres.in/api/register';
    try {
      // final response = await http.post(
      //   url,
      //   body: json.encode(
      //     {
      //       'email': signUpUserData['name'],
      //       'password': signUpUserData['job'],
      //     },
      //   ),
      // );
      // print('................................................${response.body}');

      // final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // if (extractedData == null) {
      //   return;
      // }
      final extractedData = { "token": "QpwL5tke4Pnpja7X4"};
      _token = extractedData['token'];
      // _userId = extractedData['id'];
      _expireyDate = DateTime.now().add(
        Duration(seconds: 10),
      );

      autoLogOuttimerset();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          // 'userId': _userId,
          'expireyDate': _expireyDate.toIso8601String(),
        },
      );
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
          // 'userId': _userId,
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
