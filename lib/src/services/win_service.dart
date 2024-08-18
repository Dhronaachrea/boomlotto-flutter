import 'dart:convert';
import 'dart:developer';
import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/services/api_service.dart';

class WinService {
  static const prefix = 'ï»¿';
  static Future getFooterBanner(params) async {
    final response = await ApiService.makeWinRequest(
        Constants.WIN_URL, 'getFooterBanner', params, null);
    var jsonString = response!.body;
    if (jsonString.startsWith(prefix)) {
      jsonString = jsonString.substring(prefix.length);
    }
    var jsonMap = json.decode(jsonString);

    return jsonMap;
  }

  static Future getGamesInfo(params) async {
    final response = await ApiService.makeWinRequest(
        Constants.WIN_URL, 'getGamesInfo', params, null);
    try {
      const prefix = 'ï»¿';
      var jsonString = response!.body;
      if (jsonString.startsWith(prefix)) {
        jsonString = jsonString.substring(prefix.length);
      }
      var jsonMap = json.decode(jsonString);
      return jsonMap;
    } catch (e) {
      log("Winning Exception : $e");
    }
  }

  static Future fetchmatchlist(params) async {
    final response = await ApiService.makeRequest(
        Constants.CMS_URL, RequestType.post, 'fetchmatchlist', params, null);
    try {
      var jsonString = response!.body;
      var jsonMap = json.decode(jsonString);

      return jsonMap;
    } catch (e) {
      log("Winning Exception : $e");
      return null;
    }
  }

  static Future getWinnerList(Map<String, dynamic> request) async {
    final response = await ApiService.makeWinRequest(
        Constants.WIN_URL, 'getWinnerList', request, null);

    try {
      var jsonString = response!.body;
      if (jsonString.startsWith(prefix)) {
        jsonString = jsonString.substring(prefix.length);
      }
      var jsonMap = json.decode(jsonString);

      return jsonMap;
    } catch (e) {
      log("Winning Exception : $e");
      return null;
    }
  }
}
