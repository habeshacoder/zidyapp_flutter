import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zigyapp/widget/signin_widget.dart';
import 'package:zigyapp/widget/signup_widget.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;

  var _isLoading = false;
  final _passwordController = TextEditingController();
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

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 60, left: 20, right: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 94.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: const Text(
                          'Zigy App',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),

                    if (_authMode == AuthMode.Login) SignInWidget(),

                    //sign up widget
                    if (_authMode == AuthMode.Signup) SignUpWidget(),

                    MaterialButton(
                      child: Text(
                          '${_authMode == AuthMode.Login ? 'Register' : 'Sign In'} instead'),
                      onPressed: _switchAuthMode,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
