import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miles/screens/signin.dart';

import '../helper/styles.dart';

class Lander extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "tsikl",
                  textAlign: TextAlign.center,
                  style: titleStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: Image.asset("assets/images/bicycle_black_yellow.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                      child: Text(
                        "Sign in with your Work Account",
                        style: buttonStyle,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      }),
                ),
                ElevatedButton(
                    child: Text(
                      "Sign up",
                      style: buttonStyle,
                    ),
                    onPressed: null)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
