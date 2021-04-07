import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:miles/helper/dataProvider.dart';
import 'package:miles/helper/styles.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:latlng/latlng.dart';

import 'package:map/map.dart' as NavMap;

class StartRide extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartRideState();
  }
}

class StartRideState extends State<StartRide> {
  final Future<dynamic> _rideStationData = getRideStationData();
  late final controller;
  late Map rideInfo;
  Map stationInfo = {
    "latitude": 0,
    "longitude": 0,
  };

  @override
  void initState() {
    super.initState();
    controller = NavMap.MapController(
      location: LatLng(stationInfo["latitude"], stationInfo["longitude"]),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return FutureBuilder<dynamic>(
      future: _rideStationData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget mapWidget;
        if (snapshot.hasData) {
          // Success
          print(snapshot.data);
          rideInfo = snapshot.data["rideData"];
          stationInfo = snapshot.data["stationData"];

          mapWidget = Expanded(
            flex: 53,
            child: GestureDetector(
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
                  mapWidget,
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
