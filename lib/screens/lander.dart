import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miles/global.dart';
import 'package:miles/helper/apiHelper.dart';
import 'package:miles/helper/sharedPreferences.dart';
import 'package:miles/screens/home/home.dart';
import 'package:miles/screens/signin.dart';

import '../helper/styles.dart';

class Lander extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LanderState();
  }
}

class LanderState extends State<Lander> {
  bool isPressed = false;

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
                      onPressed: isPressed
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()),
                              );
                            }),
                ),
                ElevatedButton(
                    child: Text(
                      "Express Sign in",
                      style: buttonStyle,
                    ),
                    onPressed: isPressed
                        ? null
                        : () {
                            setState(() {
                              isPressed = true;
                            });



                            try {
                              dynamic email = "";
                              dynamic token = "";
                              getFromSharedPref("email").then((value) {
                                if (value.runtimeType != String) {
                                  showSnackBar("No user credentials found");
                                  clearSharedPreferences();
                                  return;
                                }
                                email = value;
                                getFromSharedPref("token").then((value) {
                                  if (value.runtimeType != String) {
                                    showSnackBar("No access token found");
                                    clearSharedPreferences();
                                    return;
                                  }
                                  token = value;
                                  print(token);

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(right: 16),
                                              child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                  ))),
                                          Text(
                                            "Retrieving info...",
                                            style: snackBarStyle,
                                          ),
                                        ],
                                      )));

                                  Map<String, String> authMap = {
                                    "email": email,
                                    "token": token,
                                  };
                                  apiRequest(PROTOCOL, AUTHORITY, "auth-status",
                                          authMap)
                                      .catchError((error) {
                                    showSnackBar("Server unreachable");
                                  }).then((response) {
                                    print(response.statusCode);
                                    if (response.statusCode == 200) {
                                      showSnackBar("Express sign in");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                    } else if (response.statusCode == 403) {
                                      showSnackBar("Invalid token");
                                      clearSharedPreferences();
                                    } else {
                                      setState(() {
                                        isPressed = false;
                                      });
                                      showSnackBar("Server is not responding at the moment");
                                    }
                                  });
                                });
                              });
                            } catch (e) {
                              clearSharedPreferences();
                            }
                          })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearSharedPreferences() {
    clearSharedPref().then((status) {
      if (status) {
        showSnackBar("SharedPreferences cleared");

      } else {
        showSnackBar("Failed to clear SharedPreferences");
      }
    });
  }

  void showSnackBar (String desc) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Text(
              desc,
              style: snackBarStyle,
            ),
          ],
        )));
  }
}
