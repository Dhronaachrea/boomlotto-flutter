import 'dart:convert';
import 'dart:developer';
import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/services/api_service.dart';

class IGEService {
  static Future getTicketDetails(params) async {
    final response = await ApiService.makeRequest(
      Constants.GAME_URL,
      RequestType.get,
      'InstantGameEngineMS/api/bo/getTicketDetails',
      params,
      null,
    );

    try {
      var jsonString = response!.body;
      var jsonMap = json.decode(jsonString);
      return jsonMap;
    } catch (e) {
      log("IGE Exception : $e");
      return null;
    }
  }
}
