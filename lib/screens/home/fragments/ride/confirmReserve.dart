import 'package:flutter/material.dart';
import 'package:miles/helper/styles.dart';

class RideConfirmReserve extends StatefulWidget {
  final Map stationInfo;

  RideConfirmReserve({
    required this.stationInfo
  });

  @override
  State<StatefulWidget> createState() {
    return RideConfirmReserveState(stationInfo: stationInfo);
  }

}

class RideConfirmReserveState extends State<RideConfirmReserve> {
  final Map stationInfo;

  RideConfirmReserveState({required this.stationInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    "Reserve your bike",
                    style: subHeader2Style,
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    stationInfo["stationName"],
                    style: subHeader2Style,
                  )),
            ],
          ),
        ),
      ),
    );
  }

}