import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:zigyapp/model/created_user_model.dart';

class CreatedUserProvider with ChangeNotifier {
  List<CreatedUserModel> _createdUserList = [];

  List<CreatedUserModel> get createdUsersList {
    return _createdUserList;
  }

  Future<void> createUser(Map<String, dynamic> createUser) async {
    final url = 'https://reqres.in/api/users';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': createUser['name'],
            'job': createUser['job'],
          },
        ),
      );
      print('................................................${response.body}');
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      CreatedUserModel loadedUser = CreatedUserModel(
          id: extractedData['id'],
          name: createUser['name'],
          job: createUser['job'],
          createdAt: extractedData['createdAt']);
      _createdUserList.add(loadedUser);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
