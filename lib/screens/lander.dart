import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miles/global.dart';
import 'package:miles/helper/apiHelper.dart';
import 'package:miles/helper/sharedPreferences.dart';
import 'package:miles/screens/home/home.dart';
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
                      "Express Sign in",
                      style: buttonStyle,
                    ),
                    onPressed: () {
                      try {
                        String email = "";
                        String token = "";
                        getFromSharedPref("email").then((value) {
                          email = value;
                          getFromSharedPref("token").then((value) {
                            token = value;

                            Map<String, String> authMap = {
                              "email": email,
                              "token": token,
                            };
                            apiRequest(
                                    PROTOCOL, AUTHORITY, "auth-status", authMap)
                                .catchError((error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Row(
                                children: [
                                  Text(
                                    "Server unreachable",
                                    style: snackBarStyle,
                                  ),
                                ],
                              )));
                            }).then((response) {
                              print(response.statusCode);
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Row(
                                  children: [
                                    Text(
                                      "Express signed in",
                                      style: snackBarStyle,
                                    ),
                                  ],
                                )));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              } else if (response.statusCode == 403) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Row(
                                  children: [
                                    Text(
                                      "Invalid token",
                                      style: snackBarStyle,
                                    ),
                                  ],
                                )));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Row(
                                  children: [
                                    Text(
                                      "Server is not responding at the moment",
                                      style: snackBarStyle,
                                    ),
                                  ],
                                )));
                              }
                            });
                          });
                        });
                      } on Exception {
                        clearSharedPref().then((status) {
                          if (status) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
                              children: [
                                Text(
                                  "SharedPreferences cleared",
                                  style: snackBarStyle,
                                ),
                              ],
                            )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
                              children: [
                                Text(
                                  "Failed to clear SharedPreferences",
                                  style: snackBarStyle,
                                ),
                              ],
                            )));
                          }
                        });
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
