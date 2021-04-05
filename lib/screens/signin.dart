import 'package:flutter/material.dart';
import 'package:miles/global.dart';
import 'package:miles/helper/apiHelper.dart';

import '../helper/styles.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Sign in",
                  style: headerStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    style: textFieldStyle,
                    controller: userController,
                    decoration: InputDecoration(
                      hintText: "Enter your work email address",
                      hintStyle: hintStyle,
                      labelText: "Email",
                      labelStyle: labelStyle,
                    ),
                    validator: (value) {
                      // Negation is true
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value.toString())) {
                        return 'Please enter a valid address';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    obscureText: true,
                    controller: passController,
                    style: textFieldStyle,
                    decoration: InputDecoration(
                      hintText: "",
                      hintStyle: hintStyle,
                      labelText: "Password",
                      labelStyle: labelStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: ElevatedButton(
                    child: Text(
                      "Sign in",
                      style: buttonStyle,
                    ),
                    onPressed: isPressed
                        ? null
                        : () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isPressed = true;
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                                  Text("Retrieving info..."),
                                ],
                              )));

                              Map<String, String> requestMap = {
                                "email": userController.text,
                                "password": passController.text,
                              };

                              apiRequest(
                                      PROTOCOL, AUTHORITY, 'login', requestMap)
                                  .then((response) {
                                print(response.body);
                                if (response.statusCode == 200) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Row(
                                    children: [
                                      Text("Signed in"),
                                    ],
                                  )));
                                  // return User.fromJson(jsonDecode(response.body));
                                } else if (response.statusCode == 403) {
                                  setState(() {
                                    isPressed = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Row(
                                    children: [
                                      Text("Invalid credentials"),
                                    ],
                                  )));
                                } else {
                                  setState(() {
                                    isPressed = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Row(
                                    children: [
                                      Text(
                                          "Server is not responding at the moment"),
                                    ],
                                  )));
                                }
                              });
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
