import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miles/helper/dataProvider.dart';
import 'package:miles/helper/styles.dart';
import 'package:shimmer/shimmer.dart';

class StartRide extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartRideState();
  }
}

class StartRideState extends State<StartRide> {
  final Future<dynamic> _rideStationData = getRideStationData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _rideStationData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget campusNameText;
        Widget availableStations;
        if (snapshot.hasData) {
          // Success
          print(snapshot.data);
          Map rideInfo = snapshot.data["rideData"];
          Map stationInfo = snapshot.data["stationData"];
          campusNameText = Container(
            child: Text(
              rideInfo["make"] +
                  stationInfo["stationName"],
              style: subHeaderStyle,
            ),
          );
          availableStations = Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: const Color(0xffF01B46),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    "No bikes are available at this moment",
                    style: cardHeroTextStyleWhite,
                  )));
        } else if (snapshot.hasError) {
          print(snapshot.error);
          // Error
          campusNameText = Container(
              child: Text(
            "Error fetching information",
            style: subHeaderStyle,
          ));
          availableStations = Container();
        } else {
          // Loading
          campusNameText = Shimmer.fromColors(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: const Color(0xff32b92d),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              baseColor: Colors.black12,
              highlightColor: Colors.white);
          availableStations = Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Shimmer.fromColors(
              child: Text("hi"),
              baseColor: Colors.black12,
              highlightColor: Colors.white,
            ),
          );
        }
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
                  campusNameText,
                  Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "Available Now",
                        style: subHeader2Style,
                      )),
                  availableStations,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
