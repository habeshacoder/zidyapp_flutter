import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zigyapp/provider/auth.dart';
import 'package:zigyapp/provider/signup_form_handler.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  // use it to manage circular pregress indicator
  bool isSendingSignUpRequest = false;
  //store user data
  Map<String, dynamic> _authSignUpData = {
    'email': '',
    'password': '',
  };
  //declare each focusnode
  var emailFocusNode;
  var passwordFocusNode;
  //initialize each field's key
  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormState> _SignUpformKey = GlobalKey();
  //controller
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //init focusnodes
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    //add listner

    emailFocusNode.addListener(() {
      if (!(emailFocusNode.hasFocus)) {
        emailFieldKey.currentState!.validate();
      }
    });
    passwordFocusNode.addListener(() {
      if (!(passwordFocusNode.hasFocus)) {
        passwordFieldKey.currentState!.validate();
      }
    });
  }

//clean memory
  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
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
  

  //sign up method
  void _submit() async {
    print('object......................................BEGIN SUBMTING FORM');
    if (!_SignUpformKey.currentState!.validate()) {
      return;
    }
    _SignUpformKey.currentState!.save();

    setState(() {
      isSendingSignUpRequest = true;
    });
    try {
      print(
          '.................................TRY BLOCK INSIDE SUBMIT BEFOR CALLING');
      await Provider.of<Auth>(context, listen: false)
          .signUpUser(_authSignUpData);
      print(
          '.................................TRY BLOCK INSIDE SUBMIT AFTER CALLING SIGN UP');
    } on HttpException catch (error) {
      print(error);
      print('.....................err');

      var errorMessage = 'authenticate faild';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'this email address is already in use';
      }
      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'this is not a valid email';
      }
      if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'this password is too weak';
      }
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = ' could not find a user with that email';
      }
      if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'invalid password ';
      }
      showalert(errorMessage);
    } catch (error) {
      print(error);
      print('object');

      const errorMessage = 'could not authenticate you .please try again';
      showalert('$error');
    }
    setState(() {
      isSendingSignUpRequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _SignUpformKey,
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
                    suffixIcon: Icon(Icons.email),
                    suffixIconColor: Colors.grey,
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
                    hintText: 'E-Mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // controller: _emailController,
                  validator: SignUpFormHandler.emailValidator,
                  focusNode: emailFocusNode,
                  key: emailFieldKey,

                  onSaved: (newValue) {
                    _authSignUpData['email'] = newValue!;
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
                    suffixIcon: Icon(Icons.remove_red_eye),
                    suffixIconColor: Colors.grey,
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
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  validator: SignUpFormHandler.passwordValidator,
                  focusNode: passwordFocusNode,
                  key: passwordFieldKey,
                  onFieldSubmitted: (value) => _submit(),
                  onSaved: (newValue) {
                    _authSignUpData['password'] = newValue!;
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
                    child: Text('Sign Up'),
                    onPressed: _submit,
                  ),
                ),
        ),
      ],
    );
  }
}
