import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:zigyapp/provider/auth.dart';
import 'package:zigyapp/provider/create_user_form_handler.dart';
import 'package:zigyapp/provider/created_user_provider.dart';
import 'package:zigyapp/provider/signup_form_handler.dart';

class CreateUserWidget extends StatefulWidget {
  const CreateUserWidget({super.key});

  @override
  State<CreateUserWidget> createState() => _CreateUserWidgetState();
}

class _CreateUserWidgetState extends State<CreateUserWidget> {
  // use it to manage circular pregress indicator
  bool isSendingSignUpRequest = false;
  //store user data
  Map<String, dynamic> createUserData = {
    'name': '',
    'job': '',
  };
  //declare each focusnode
  var nameFocusNode;
  var jobFocusNode;
  //initialize each field's key
  final nameFieldKey = GlobalKey<FormFieldState>();
  final jobFieldKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormState> _createUserFormKey = GlobalKey();
  //controller
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //init focusnodes
    nameFocusNode = FocusNode();
    jobFocusNode = FocusNode();
    //add listner

    nameFocusNode.addListener(() {
      if (!(nameFocusNode.hasFocus)) {
        nameFieldKey.currentState!.validate();
      }
    });
    jobFocusNode.addListener(() {
      if (!(jobFocusNode.hasFocus)) {
        jobFieldKey.currentState!.validate();
      }
    });
  }

//clean memory
  @override
  void dispose() {
    nameFocusNode.dispose();
    jobFocusNode.dispose();
    super.dispose();
  }

  void showalert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('an error occured'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('okay'),
            )
          ],
        );
      },
    );
  }

  // method
  void createUser() async {
    print(
        'object inside setstate..............................................................');
    if (!_createUserFormKey.currentState!.validate()) {
      return;
    }
    _createUserFormKey.currentState!.save();

    setState(() {
      isSendingSignUpRequest = true;
    });
    try {
      await Provider.of<CreatedUserProvider>(context, listen: false).createUser(createUserData);
    } on HttpException catch (error) {
      print(error);
      var errorMessage = 'authenticate faild';
      showalert(errorMessage);
    } catch (error) {
      showalert('$error');
    }
    setState(() {
      isSendingSignUpRequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.grey[100],
      child: Container(
        margin: EdgeInsets.only(left: 30,right: 30,top:40,bottom: 20),
        child: Column(
          children: [
            Form(
              key: _createUserFormKey,
              child: Column(
                children: [
                  Container(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 7),
                        filled: true,
                        fillColor: Colors.white60,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0),
                        ),
                        // focusColor: Colors.grey,
                        // labelText: 'Full Name',
                        hintText: 'name',
                      ),
                      // controller: _emailController,
                      validator: CreateUserFormHandler.nameValidator,
                      focusNode: nameFocusNode,
                      key: nameFieldKey,
      
                      onSaved: (newValue) {
                        createUserData['name'] = newValue;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      maxLines: 1,
                      decoration: const InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 7),
                        filled: true,
                        fillColor: Colors.white60,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0),
                        ),
                        // focusColor: Colors.grey,
                        // labelText: 'Full Name',
                        hintText: 'job',
                      ),
                      obscureText: true,
                      validator: SignUpFormHandler.passwordValidator,
                      focusNode: jobFocusNode,
                      key: jobFieldKey,
                      onFieldSubmitted: (value) {
                        createUser();
                      },
                      onSaved: (newValue) {
                        createUserData['job'] = newValue;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: isSendingSignUpRequest
                  ? CircularProgressIndicator()
                  : Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF00A19A),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: double.infinity,
                      child: MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        child: Text('Create User'),
                        onPressed: createUser,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
