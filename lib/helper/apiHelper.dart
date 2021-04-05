import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> apiRequest(protocol, authority, api, body) {
  return http.post(
      protocol == "https"
          ? Uri.https(authority, api)
          : Uri.http(authority, api),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"));
}
