import 'package:flutter/material.dart';
import 'package:miles/helper/sharedPreferences.dart';
import 'package:miles/helper/styles.dart';

class RideNow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RideNowState();
  }
}

class RideNowState extends State<RideNow> {
  final Future<dynamic> _organizationName = getFromSharedPref("organizationName");

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<dynamic>(
      future: _organizationName, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        String campusName = "";
        if (snapshot.hasData) {
          // Success
          campusName = snapshot.data;
        } else if (snapshot.hasError) {
          // Error
          campusName = "Error fetching information";
        } else {
         // Loading
          campusName = "Loading...";
        }
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "RIDE NOW",
                  style: headerStyle,
                ),
                Text(
                  campusName,
                  style: subHeaderStyle,
                ),
              ],
            ),
          ),
        );
      },
    );

  }
}
