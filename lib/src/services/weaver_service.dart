import 'dart:convert';
import 'dart:developer';
import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/services/api_service.dart';

class WeaverService {
  static Future<Map<String, dynamic>> playerInbox(request) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'username': 'weaver',
      'password': 'password',
    };
    final response = await ApiService.makeRequest(Constants.WEAVER_URL,
        RequestType.post, 'playerInbox', request, headers);
    String jsonString = response!.body;
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    log(response.body);

    return jsonMap;
  }

  static Future<Map<String, dynamic>> inboxActivity(request) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'username': 'weaver',
      'password': 'password',
    };
    final response = await ApiService.makeRequest(Constants.WEAVER_URL,
        RequestType.post, 'inboxActivity', request, headers);
    String jsonString = response!.body;
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    log(response.body);

    return jsonMap;
  }

  static Future transactionDetails(Map<String, dynamic> request) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await ApiService.makeRequest(Constants.WEAVER_URL,
        RequestType.post, 'transactionDetails', request, headers);
    try {
      var jsonString = response!.body;
      log(jsonString);
      var jsonMap = json.decode(jsonString);

      return jsonMap;
    } catch (e) {
      log("Weaver Exception : $e");
      return null;
    }
  }
}
