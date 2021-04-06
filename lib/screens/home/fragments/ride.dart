import 'package:flutter/material.dart';
import 'package:miles/helper/apiHelper.dart';
import 'package:miles/helper/sharedPreferences.dart';
import 'package:miles/helper/styles.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class RideNow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RideNowState();
  }
}

class RideNowState extends State<RideNow> {
  final Future<dynamic> _userInfo =
      getAllFromSharedPref();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _userInfo, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        String campusName = "";
        if (snapshot.hasData) {
          // Success
          print(snapshot.data.runtimeType);
          print(snapshot.data);
          campusName = snapshot.data["organizationName"];
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Shimmer.fromColors(
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      itemCount: 7,
                      itemBuilder: (BuildContext context, int index) =>
                          new Container(
                              color: Colors.green,
                              child: new Center(
                                child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: new Text('$index'),
                                ),
                              )),
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, index.isEven ? 2 : 1),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                    baseColor: Colors.black12,
                    highlightColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
