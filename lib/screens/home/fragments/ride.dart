import 'package:flutter/material.dart';
import 'package:miles/helper/styles.dart';

class RideNow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RideNowState();
  }
}

class RideNowState extends State<RideNow> {
  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}
