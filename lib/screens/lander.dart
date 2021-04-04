import 'package:flutter/material.dart';

class LanderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 Text(
                   "tsikl",
                   textAlign: TextAlign.center,
                 ),
                 Icon(Icons.pages),
                 ElevatedButton(
                     child: Text("Sign in with your Work Account"),
                     onPressed: null
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