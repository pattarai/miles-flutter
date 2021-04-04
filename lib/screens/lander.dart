import 'dart:ui';

import 'package:flutter/material.dart';

class LanderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 Text(
                   "tsikl",
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontFamily: "Dosis",
                     fontWeight: FontWeight.w300,
                     fontSize: 70
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                   child: Image.asset("assets/images/bicycle_black_yellow.png"),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(bottom: 8.0),
                   child: ElevatedButton(
                       child: Text("Sign in with your Work Account"),
                       onPressed: null
                   ),
                 ),
                 ElevatedButton(
                     child: Text("Sign up"),
                     onPressed: null
                 )
               ],
             ),
          ),
        ),
      ),
    );
  }

}