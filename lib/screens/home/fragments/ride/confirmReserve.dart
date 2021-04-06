import 'package:flutter/material.dart';
import 'package:miles/helper/styles.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:map/map.dart' as NavMap;

class RideConfirmReserve extends StatefulWidget {
  final Map stationInfo;

  RideConfirmReserve({required this.stationInfo});

  @override
  State<StatefulWidget> createState() {
    return RideConfirmReserveState(stationInfo: stationInfo);
  }
}

class RideConfirmReserveState extends State<RideConfirmReserve> {
  final Map stationInfo;
  late final controller;

  RideConfirmReserveState({required this.stationInfo});

  @override
  void initState() {
    super.initState();
    controller = NavMap.MapController(
      location: LatLng(stationInfo["latitude"], stationInfo["longitude"]),
    );
  }


  void _gotoDefault() {
    controller.center = LatLng(stationInfo["latitude"], stationInfo["longitude"]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 20,
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
            Expanded(
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
            ),
            Expanded(

                flex: 7,
                child: Container(
                  padding: EdgeInsets.only(top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(onPressed: null, child: Text("Open in Maps")),
                      ElevatedButton(onPressed: null, child: Text("Reserve")),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
