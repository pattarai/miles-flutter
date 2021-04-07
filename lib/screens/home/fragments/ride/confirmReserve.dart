import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miles/global.dart';
import 'package:miles/helper/apiHelper.dart';
import 'package:miles/helper/sharedPreferences.dart';
import 'package:miles/helper/styles.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:map/map.dart' as NavMap;
import 'package:miles/screens/home/fragments/ride/startRide.dart';
import 'package:url_launcher/url_launcher.dart';

class RideConfirmReserve extends StatefulWidget {
  final Map stationInfo;
  final Map userInfo;

  RideConfirmReserve({required this.stationInfo, required this.userInfo});

  @override
  State<StatefulWidget> createState() {
    return RideConfirmReserveState(
        stationInfo: stationInfo, userInfo: userInfo);
  }
}

class RideConfirmReserveState extends State<RideConfirmReserve> {
  bool reserveLoading = false;
  bool reserved = false;

  final Map stationInfo;
  final Map userInfo;

  late final controller;

  RideConfirmReserveState({required this.stationInfo, required this.userInfo});

  @override
  void initState() {
    super.initState();
    controller = NavMap.MapController(
      location: LatLng(stationInfo["latitude"], stationInfo["longitude"]),
    );
  }

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
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            launch("http://www.google.com/maps/place/" +
                                stationInfo["latitude"].toString() +
                                "," +
                                stationInfo["longitude"].toString());
                          },
                          child: Text("Open in Maps")),
                      ElevatedButton(
                          onPressed: reserveLoading
                              ? null
                              : reserved
                                  ? null
                                  : () {
                                      setState(() {
                                        reserveLoading = true;
                                      });
                                      Map<String, String> apiData = {
                                        "email": userInfo["email"],
                                        "token": userInfo["token"],
                                        "stationID":
                                            stationInfo["stationID"].toString(),
                                      };

                                      apiRequest(PROTOCOL, AUTHORITY,
                                              "reserve-bike", apiData)
                                          .then((response) {
                                        if (response.statusCode == 200) {
                                          var body = jsonDecode(response.body);
                                          if (body == "no-available-bikes") {
                                            setState(() {
                                              reserved = false;
                                              reserveLoading = false;
                                            });
                                            // Show AlertDialog
                                            showSnackBar(
                                                "No bikes are available at this moment");
                                            print("No bikes");
                                          } else {
                                             insertToSharedPref("rideInfo", response.body.toString()).then((x) {
                                               insertToSharedPref("stationInfo", jsonEncode(stationInfo)).then((x){
                                                 setState(() {
                                                   reserved = true;
                                                   reserveLoading = false;
                                                 });
                                                 showSnackBar("Reserved");
                                                 print(response.body);
                                                 // Navigate to confirmation screen
                                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartRide()));
                                               }) ;

                                             });

                                          }
                                        }
                                        // Handle other status codes
                                      });
                                    },
                          child: reserveLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ))
                              : reserved
                                  ? Text("Done")
                                  : Text("Reserve")),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
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
