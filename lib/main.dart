import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zigyapp/provider/auth.dart';
import 'package:zigyapp/provider/created_user_provider.dart';
import 'package:zigyapp/provider/page_two_users_provider.dart';
import 'package:zigyapp/view/Authentication_screen.dart';
import 'package:zigyapp/view/Home.dart';
import 'package:zigyapp/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (context) => CreatedUserProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PageTwoUsersProvider(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth
                ? Home()
                : FutureBuilder(
                    future: auth.tryAutoLogIn(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : snapshot.data == false
                                ? AuthScreen()
                                : Home(),
                  ),
          ),
        ));
  }
}
