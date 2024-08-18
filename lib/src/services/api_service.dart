import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

enum RequestType { get, post, delete, put }

class ApiService {
  static Future<Response?> makeRequest(String baseUrl, RequestType requestType,
      String path, parameter, dynamic headers) async {
    var client = http.Client();

    switch (requestType) {
      case RequestType.get:
        String queryString = Uri(queryParameters: parameter).query;
        final Response response = await client.get(
          Uri.parse('$baseUrl/$path?' + queryString),
          headers: headers,
        );
        if (response.statusCode == 200) {
          return response;
        } else {
          return null;
        }
      case RequestType.post:
        return client.post(
          Uri.parse("$baseUrl/$path"),
          headers: headers,
          body: jsonEncode(parameter),
        );
      case RequestType.put:
        return client.put(
          Uri.parse("$baseUrl/$path"),
          headers: headers,
          body: jsonEncode(parameter),
        );
      default:
        return throw Exception("The HTTP request method is not found");
    }
  }

  static Future<Response?> makeWinRequest(
      String baseUrl, String path, parameter, headers) async {
    var client = http.Client();
    return client.post(
      Uri.parse("$baseUrl$path"),
      headers: headers,
      body: jsonEncode(parameter),
    );
  }
}
