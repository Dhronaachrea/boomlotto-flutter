import 'dart:convert';
import 'dart:developer';
import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/services/api_service.dart';

class RamService {
  static Future getCountryList() async {
    Map<String, String> headers = {"merchantCode": "INFINITI"};

    final response = await ApiService.makeRequest(Constants.RAM_URL,
        RequestType.get, 'preLogin/getCountryList', null, headers);
    var jsonString = response!.body;
    var jsonMap = json.decode(jsonString);

    if (jsonMap["errorCode"] == 0) {
      return jsonMap["data"];
    }
  }

  static Future sendRegOtp(params) async {
    Map<String, String> headers = {"merchantCode": "INFINITI"};

    final response = await ApiService.makeRequest(Constants.RAM_URL,
        RequestType.get, 'preLogin/sendRegOtp', params, headers);
    var jsonString = response!.body;
    var jsonMap = json.decode(jsonString);
    log(jsonString);

    return jsonMap;
  }

  static Future registerPlayerWithOtp(params) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "merchantCode": "INFINITI"
    };

    final response = await ApiService.makeRequest(Constants.RAM_URL,
        RequestType.post, 'preLogin/registerPlayerWithOtp', params, headers);

    var jsonString = response!.body;
    log(jsonString);
    var jsonMap = json.decode(jsonString);

    return jsonMap;
  }
}
