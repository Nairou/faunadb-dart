import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'expr.dart';

class FaunaClient {
  final String secret;

  FaunaClient({@required this.secret});

  Future<Expr> query(Expr parameter) async {
    var auth = "Basic " + base64Encode(utf8.encode(secret));
    var response = await http.post("https://db.fauna.com:443", body: parameter.toJson(), headers: {
      HttpHeaders.authorizationHeader: auth,
      "Content-Type": "text/plain; charset=UTF-8",
    });
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body)["resource"];
      print(response);
    }
    var temp2 = response.body;
    return parameter;
  }
}
