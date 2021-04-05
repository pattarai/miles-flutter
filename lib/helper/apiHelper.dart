import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> apiRequest(protocol, authority, api, body) {
  try {
    return http
        .post(
            protocol == "https"
                ? Uri.https(authority, api)
                : Uri.http(authority, api),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: body,
            encoding: Encoding.getByName("utf-8"))
        .catchError((error) => error);
  } catch(e) {
    return Future.error(Exception("host-unreachable"));
  }
}
