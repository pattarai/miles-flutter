import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:miles/helper/dataProvider.dart';
import 'package:miles/helper/styles.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:map/map.dart' as NavMap;
import 'package:url_launcher/url_launcher.dart';

class StartRide extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartRideState();
  }
}

class StartRideState extends State<StartRide> {
  final Future<dynamic> _rideStationData = getRideStationData();
  Map rideInfo = {};
  Map stationInfo = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _rideStationData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          Widget mapWidget;
          if (snapshot.hasData) {
            // Success
            print(snapshot.data);
            rideInfo = snapshot.data["rideData"];
            stationInfo = snapshot.data["stationData"];

            final controller = NavMap.MapController(
              zoom: 17,
              location:
                  LatLng(stationInfo["latitude"], stationInfo["longitude"]),
            );
            void _gotoDefault() {
              controller.center =
                  LatLng(stationInfo["latitude"], stationInfo["longitude"]);
            }

            void _onDoubleTap() {
              controller.zoom += 0.5;
            }

            late Offset _dragStart;
            double _scaleStart = 1.0;

            void _onScaleStart(ScaleStartDetails details) {
              _dragStart = details.focalPoint;
              _scaleStart = 1.0;
            }

            void _onScaleUpdate(ScaleUpdateDetails details) {
              final scaleDiff = details.scale - _scaleStart;
              _scaleStart = details.scale;

              if (scaleDiff > 0) {
                controller.zoom += 0.02;
              } else if (scaleDiff < 0) {
                controller.zoom -= 0.02;
              } else {
                final now = details.focalPoint;
                final diff = now - _dragStart;
                _dragStart = now;
                controller.drag(diff.dx, diff.dy);
              }
            }

            mapWidget = GestureDetector(
              onDoubleTap: _onDoubleTap,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: (details) {
                print(
                    "Location: ${controller.center.latitude}, ${controller.center.longitude}");
              },
              child: Stack(
                children: [
                  NavMap.Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Center(
                    child: Icon(Icons.location_pin, color: Colors.red),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            // Error
            mapWidget = Container();
          } else {
            mapWidget = Container();
          }
          return Scaffold(
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 50,
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
                              onEnd: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 55, child: mapWidget),
                  Expanded(
                      flex: 17,
                      child: Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  launch("http://www.google.com/maps/place/" +
                                      stationInfo["latitude"].toString() +
                                      "," +
                                      stationInfo["longitude"].toString());
                                },
                                child: Text(
                                  "Open in Maps",
                                  style: buttonStyle,
                                )),
                            Row(

                              children: [
ElevatedButton(onPressed: null, child: Text("Cancel Ride"))
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        });
  }

  void showSnackBar(String desc) {
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
