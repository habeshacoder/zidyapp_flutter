import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:zigyapp/model/page_two_users_model.dart';
import 'package:http/http.dart' as http;

class PageTwoUsersProvider with ChangeNotifier {
  List<PageTwoUsersModel> _pageTwoUsersList = [];

  List<PageTwoUsersModel> get pageTwoUsersList {
    return _pageTwoUsersList;
  }

  Future<void> fectAndPut() async {
    final url = 'https://reqres.in/api/users?page=2';
    try {
      final response = await http.get(url);
      print('................................................${response.body}');

      final extractedDataFirstData =
          json.decode(response.body) as Map<String, dynamic>;
      print(
          'after decode ....................................${extractedDataFirstData['data']}');
      if (extractedDataFirstData == null) {
        return;
      }
      List<PageTwoUsersModel> loadedUsersList = [];
      extractedDataFirstData['data'].forEach(
        (user) {
          loadedUsersList.add(
            PageTwoUsersModel(
                id: user['id'],
                firstName: user['first_name'],
                lastName: user['last_name'],
                email: user['email'],
                avatar: user['avatar']),
          );
        },
      );
      _pageTwoUsersList = loadedUsersList;
      print(
          '....................................................${_pageTwoUsersList}');
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
