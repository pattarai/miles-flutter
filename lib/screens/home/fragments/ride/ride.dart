import 'package:flutter/material.dart';
import 'package:miles/helper/dataProvider.dart';
import 'package:miles/helper/styles.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import 'confirmReserve.dart';

class RideNow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RideNowState();
  }
}

class RideNowState extends State<RideNow> {
  final Future<dynamic> _rideData = getRideScreenData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _rideData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget campusNameText;
        Widget availableStations;
        if (snapshot.hasData) {
          // Success
          print(snapshot.data.runtimeType);
          campusNameText = Container(
            child: Text(
              snapshot.data["userData"]["organizationName"],
              style: subHeaderStyle,
            ),
          );
          availableStations = snapshot.data["availBikeData"].length == 0
              ? Container(
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
                  ))
              : StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  itemCount: snapshot.data["availBikeData"].length,
                  itemBuilder: (BuildContext context, int index) =>
                      new InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RideConfirmReserve(
                                    stationInfo:
                                        snapshot.data["availBikeData"][index],
                                    userInfo: snapshot.data["userData"],
                                  )));
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              snapshot.data["availBikeData"][index]
                                  ["stationName"],
                              style: cardHeroTextStyleWhite,
                            ),
                            Text(
                              snapshot.data["availBikeData"][index]
                                          ["available"]
                                      .toString() +
                                  " available",
                              style: cardSubHeroTextStyleWhite,
                            ),
                          ],
                        )),
                  ),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.fit(2),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                );
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
          campusNameText = Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Shimmer.fromColors(
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
                highlightColor: Colors.white),
          );
          availableStations = Shimmer.fromColors(
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              itemCount: 7,
              itemBuilder: (BuildContext context, int index) => new Container(
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
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            baseColor: Colors.black12,
            highlightColor: Colors.white,
          );
        }
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
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
        );
      },
    );
  }
}
