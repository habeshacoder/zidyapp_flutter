import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Text('We are trying to load your data. '),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
