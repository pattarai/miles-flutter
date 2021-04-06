import 'dart:convert';

import 'package:miles/helper/sharedPreferences.dart';
import 'package:http/http.dart';

import '../global.dart';
import 'apiHelper.dart';

Future<dynamic> getRideScreenData() async {
  Map userData = await getAllFromSharedPref();
  Map<String, String> userTokenData = {
    "email": userData["email"],
    "token": userData["token"],
  };
  Response response =
      await apiRequest(PROTOCOL, AUTHORITY, "get-avail-bikes", userTokenData);

  if (response.statusCode == 200) {
    List availBikeData = jsonDecode(response.body);

    Map<String, dynamic> allData = {
      "userData": userData,
      "availBikeData": availBikeData,
    };
    return allData;
  } else {
    throw Exception(response.statusCode.toString() + "-error");
  }

}
