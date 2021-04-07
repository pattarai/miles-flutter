import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:miles/helper/dataProvider.dart';
import 'package:miles/helper/styles.dart';
import 'package:flutter_countdown_timer/index.dart';

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
        } else if (snapshot.hasError) {
          print(snapshot.error);
          // Error

        } else {}
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "You're all set!",
                    style: headerStyle,
                  ),
                  Text(
                    "Start your ride within",
                    style: subHeaderStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CircleAvatar(
                      radius: 70,
                      child: CountdownTimer(
                        endTime: DateTime.now().millisecondsSinceEpoch +
                            1000 * 5 * 60,
                        widgetBuilder: (_, CurrentRemainingTime? time) {
                          if (time == null) {
                            return Text(
                              '00:00',
                              style: headerStyle,
                            );
                          }
                          return Text(
                            "${time.min == null ? "00" : time.min.toString().length < 2 ? "0" + time.min.toString() : time.min}:${time.sec == null ? "00" : time.sec.toString().length < 2 ? "0" + time.sec.toString() : time.sec}",
                            style: headerStyle,
                          );
                        },
                        onEnd: cancelRide,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  cancelRide() {}
}
