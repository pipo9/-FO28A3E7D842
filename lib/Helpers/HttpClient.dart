import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'Config.dart';

class HttpClient {
  HttpClient._privateConstructor();

  static final HttpClient _instance = HttpClient._privateConstructor();

  factory HttpClient() {
    return _instance;
  }

  Future<dynamic> postRequest(String path, headers, body) async {
    Response response;
    Map returnedResponse = Map();


    try {
      response = await post(
        Uri.https(Urls.ApiPath, path),
        headers: headers,
        body: jsonEncode(body),
      );
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
            print('done');
        if (response.body.isEmpty) {
          returnedResponse["status"] = false;
          returnedResponse["body"] = [];
        } else {
          returnedResponse["status"] = true;
          returnedResponse["body"] = jsonDecode(response.body);
          returnedResponse["message"] = 'ok';
        }
      }
      if (statusCode == 401) {
        returnedResponse["message"] = 'something went wrong';
      }
    } on SocketException {
      returnedResponse["message"] = 'something went wrong';
    }
    return returnedResponse;
  }
}
