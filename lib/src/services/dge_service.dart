import 'dart:convert';
import 'dart:developer';
import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/services/api_service.dart';

class DGEService {
  static const String DMS_URL = Constants.DMS_URL;
  static Future fetchGameData(request) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'username': 'weaver',
      'password': 'password',
    };

    final response = await ApiService.makeRequest(
        DMS_URL, RequestType.put, 'dataMgmt/fetchGameData', request, headers);

    try {
      var jsonString = response!.body;
      var jsonMap = json.decode(jsonString);
      log(response.body);

      return jsonMap;
    } catch (e) {
      log("DGE Exception : $e");
      return null;
    }
  }

  static Future ticketBuy(request) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'username': 'weaver',
      'password': 'password',
    };
    log(request.toString());
    final response = await ApiService.makeRequest(
        DMS_URL, RequestType.post, 'ticket/buy', request, headers);

    try {
      var jsonString = response!.body;
      var jsonMap = json.decode(jsonString);
      log(response.body);

      return jsonMap;
    } catch (e) {
      log("DGE Exception : $e");
      return null;
    }
  }

  static Future getTicketDetails(request) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'username': 'weaver',
      'password': 'password',
    };
    final response = await ApiService.makeRequest(
        DMS_URL, RequestType.get, 'ticket/getTicketDetails', request, headers);

    try {
      var jsonString = response!.body;
      var jsonMap = json.decode(jsonString);
      return jsonMap;
    } catch (e) {
      log("DGE Exception : $e");
      return null;
    }
  }

  static Future rmsTrackTicket(request) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'username': 'weaver',
      'password': 'password',
    };
    final response = await ApiService.makeRequest(DMS_URL, RequestType.post,
        'ticket/playMgmt/rmsTrackTicket', request, headers);

    try {
      var jsonString = response!.body;
      var jsonMap = json.decode(jsonString);

      return jsonMap;
    } catch (e) {
      log("DGE Exception : $e");
      return null;
    }
  }
}
