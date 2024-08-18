import 'dart:convert';
import 'package:boom_lotto/src/common/shared.dart';
import 'package:boom_lotto/src/constants/network_contants.dart';
import 'package:boom_lotto/src/data/model/payment_option_model.dart';
import 'package:http/http.dart' as http;
import 'package:boom_lotto/src/data/model/referral_code_model.dart';
import 'package:boom_lotto/src/data/model/signup_model.dart';
import 'model/country_list_model.dart';
import 'model/email_otp_verified_model.dart';
import 'model/emailed_otp_response_model.dart';
import 'model/game_info_model.dart';
import 'model/game_list_model.dart';
import 'model/login_model.dart';
import 'model/profile.dart';
import 'model/todo.dart';
import 'model/transaction_list_model.dart';

class NetworkService {
  Future<Todo?> fetchTodos() async {
    Map<String, String> params = {"deviceType": "MOBILE"};
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.WIN_URL + 'getFooterBanner'),
          body: json.encode(params));
      if (response.body.contains('ï»¿')) {
        print(response.body);
        var result = jsonDecode(response.body.split('ï»¿')[1]);
        return Todo.fromJson(result);
      } else {
        var result = jsonDecode(response.body);
        return Todo.fromJson(result);
      }
    } catch (e) {
      return null;
    }
  }

  Future<GameInfoModel?> fetchGameInfo() async {
    Map<String, String> params = {"deviceType": "MOBILE"};
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.WIN_URL + 'getGamesInfo'),
          body: json.encode(params));
      if (response.body.contains('ï»¿')) {
        var result = jsonDecode(response.body.split('ï»¿')[1]);
        return GameInfoModel.fromJson(result);
      } else {
        var result = jsonDecode(response.body);
        return GameInfoModel.fromJson(result);
      }
    } catch (e) {
      return null;
    }
  }

  Future<GameListModel?> fetchGameList() async {
    Map<String, String> params = {"deviceType": "MOBILE"};
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.CMS_URL + 'fetchmatchlist'),
          body: json.encode(params));
      if (response.body.contains('ï»¿')) {
        var result = jsonDecode(response.body.split('ï»¿')[1]);
        return GameListModel.fromJson(result);
      } else {
        var result = jsonDecode(response.body);
        return GameListModel.fromJson(result);
      }
    } catch (e) {
      return null;
    }
  }

  Future<LoginModel?> login(String mobileNumber) async {
    Map<String, String> headers = {"merchantCode": "INFINITI"};

    Map<String, String> params = {
      "aliasName": "www.winboom.ae",
      // "mobileNo": code.substring(1) + _mobileNumber.text
      "mobileNo": mobileNumber
    };
    print(params);
    String queryString = Uri(queryParameters: params).query;
    try {
      final response = await http.get(
          Uri.parse(
              ApiConstants.RAM_URL + 'preLogin/sendRegOtp' + '?' + queryString),
          headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        if (response.body.contains('ï»¿')) {
          var result = jsonDecode(response.body.split('ï»¿')[1]);
          return LoginModel.fromJson(result);
        }
        else {
          var result = jsonDecode(response.body);
          return LoginModel.fromJson(result);
        }
      }
    }
    catch (e) {}

    Future<CountryListModel?> fetchCountryList() async {
      Map<String, String> headers = {"merchantCode": "INFINITI"};
      try {
        final response = await http.get(
            Uri.parse(ApiConstants.RAM_URL + 'preLogin/getCountryList'),
            headers: headers);
        if (response.body.contains('ï»¿')) {
          var result = jsonDecode(response.body.split('ï»¿')[1]);
          print('contryListResponse: $result');
          return CountryListModel.fromJson(result);
        } else {
          var result = jsonDecode(response.body);
          print('contryListResponse: $result');
          return CountryListModel.fromJson(result);
        }
      } catch (e) {
        return null;
      }
    }

    Future<SignUpModel?> signUp(var param) async {
      print(json.encode(param));
      Map<String, String> headers = {
        "Content-Type": "application/json; charset=UTF-8",
        "merchantCode": "INFINITI"
      };

      try {
        final response = await http.post(
            Uri.parse(ApiConstants.RAM_URL + 'preLogin/registerPlayerWithOtp'),
            headers: headers, body: json.encode(param));
        print(response.body);

        if (response.body.contains('ï»¿')) {
          var result = jsonDecode(response.body.split('ï»¿')[1]);
          return SignUpModel.fromJson(result);
        } else {
          var result = jsonDecode(response.body);
          return SignUpModel.fromJson(result);
        }
      } catch (e) {
        return null;
      }
    }

    Future<ReferralCodeModel?> referralCode(String referralNumber) async {
      Map<String, String> headers = {
        "Content-Type": "application/json; charset=UTF-8",
        "merchantCode": "INFINITI"
      };

      Map<String, String> params = {
        "domainName": "www.winboom.ae",
        "referCode": referralNumber
      };

      try {
        final response = await http.post(
            Uri.parse(ApiConstants.WEAVER_URL + 'referCodeValidation'),
            headers: headers,
            body: json.encode(params));
        if (response.body.contains('ï»¿')) {
          var result = jsonDecode(response.body.split('ï»¿')[1]);
          return ReferralCodeModel.fromJson(result);
        } else {
          var result = jsonDecode(response.body);
          return ReferralCodeModel.fromJson(result);
        }
      } catch (e) {
        return null;
      }
    }

    Future<TransactionListModel?> fetchTransactionList(
        Map<String, dynamic> request) async {
      Map<String, String> headers = {
        "Content-Type": "application/json; charset=UTF-8"
      };

      try {
        final response = await http.post(
            Uri.parse(ApiConstants.WEAVER_URL + 'transactionDetails'),
            body: json.encode(request), headers: headers);
        print(response);
        if (response.body.contains('ï»¿')) {
          var result = jsonDecode(response.body.split('ï»¿')[1]);
          return TransactionListModel.fromJson(result);
        }
        else {
          var result = jsonDecode(response.body);
          return TransactionListModel.fromJson(result);
        }
      }
      catch (e) {
        return null;
      }
    }
  }

  Future<CountryListModel?> fetchCountryList() async {
    Map<String, String> headers = {"merchantCode": "INFINITI"};
    try {
      final response = await http.get(
          Uri.parse(ApiConstants.RAM_URL + 'preLogin/getCountryList'),
          headers: headers);
      if (response.body.contains('ï»¿')) {
        var result = jsonDecode(response.body.split('ï»¿')[1]);
        print('contryListResponse: $result');
        return CountryListModel.fromJson(result);
      }
      else {
        var result = jsonDecode(response.body);
        print('contryListResponse: $result');
        return CountryListModel.fromJson(result);
      }
    }
    catch (e) {
      return null;
    }
  }

  Future<SignUpModel?> signUp(var param) async {
    print(json.encode(param));
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "merchantCode": "INFINITI"
    };

    try {
      final response = await http.post(
          Uri.parse(ApiConstants.RAM_URL + 'preLogin/registerPlayerWithOtp'),
          headers: headers, body: json.encode(param));
      print(response.body);
      if (response.body.contains('ï»¿')) {
        var result = jsonDecode(response.body.split('ï»¿')[1]);
        return SignUpModel.fromJson(result);
      }
      else {
        var result = jsonDecode(response.body);
        return SignUpModel.fromJson(result);
      }
    }
    catch (e) {
      return null;
    }
  }

  Future<ReferralCodeModel?> referralCode(String referralNumber) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "merchantCode": "INFINITI"
    };

    Map<String, String> params = {
      "domainName": "www.winboom.ae",
      "referCode": referralNumber
    };
    String queryString = Uri(queryParameters: params).query;
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.WEAVER_URL + 'referCodeValidation'),
          headers: headers, body: json.encode(params));
      if (response.body.contains('ï»¿')) {
        var result = jsonDecode(response.body.split('ï»¿')[1]);
        return ReferralCodeModel.fromJson(result);
      }
      else {
        var result = jsonDecode(response.body);
        return ReferralCodeModel.fromJson(result);
      }
    }
    catch (e) {
      return null;
    }
  }

  Future<TransactionListModel?> fetchTransactionList(Map<String, dynamic> request) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };

    try {
      final response = await http.post(
          Uri.parse(ApiConstants.WEAVER_URL + 'transactionDetails'),
          body: json.encode(request),headers: headers);
      print(response.body);
      if (response.body.contains('ï»¿')) {
        var result = jsonDecode(response.body.split('ï»¿')[1]);
        return TransactionListModel.fromJson(result);
      }
      else {
        var result = jsonDecode(response.body);
        return TransactionListModel.fromJson(result);
      }
    }
    catch (e) {
      return null;
    }
  }
}

  Future<PaymentOptionModel?> paymentOptions() async {
    print("paymentOptions is going to be called");
    String playerToken =
        await MySharedPreferences.instance.getStringValue("playerToken");
    String playerId =
        await MySharedPreferences.instance.getStringValue("playerId");
    print("playerId : $playerId type : ${playerId.runtimeType}");
    print("playerToken : $playerToken type : ${playerToken.runtimeType}");
    Map<String, String> headers = {
      "merchantCode": "INFINITI",
      "playerId": "411997",
      "playerToken": "1tqyqgAe7K232rUaXGQiPjKz1kUNzgdlOhWhBSWZptM",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> params = {
      "domainName": "www.winboom.ae",
      "playerId": playerId,
      "txnType": "WITHDRAWAL",
      "deviceType": "PC",
      "playerToken": playerToken,
      "userAgent": "sdfsdf"
    };
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.BCB_URL + 'player/payment/options'),
          headers: headers,
          body: json.encode(params));
      print("Payment response: ${response.body}");
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        print(' Payment result:$result');
        return PaymentOptionModel.fromJson(result);
      } else {
        var result = jsonDecode(response.body);
        return PaymentOptionModel.fromJson(result);
      }
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  Future<EmailedOtpResponseModel?> getEmailOtp(String emailId) async {
    print("getEmailOtp is api is going to called");
    String playerToken =
        await MySharedPreferences.instance.getStringValue("playerToken");
    String playerId =
        await MySharedPreferences.instance.getStringValue("playerId");
    print("playerId : $playerId type : ${playerId.runtimeType}");
    print("playerToken : $playerToken type : ${playerToken.runtimeType}");
    Map<String, String> headers = {
      "merchantCode": "INFINITI",
      "playerId": "411997",
      "playerToken": "1tqyqgAe7K232rUaXGQiPjKz1kUNzgdlOhWhBSWZptM",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> params = {
      "domainName": "www.winboom.ae",
      "emailId": emailId,
      "isOtpVerification": "YES",
      "playerId": "411997"
    };
    try {
      final response = await http.post(
          Uri.parse(
              ApiConstants.RAM_URL + 'postLogin/sendVerficationEmailLink'),
          headers: headers,
          body: json.encode(params));
      print("Otp response: ${response.body}");
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        print(' Otp result:$result');
        return EmailedOtpResponseModel.fromJson(result);
      } else {
        var result = jsonDecode(response.body);
        return EmailedOtpResponseModel.fromJson(result);
      }
    } catch (e) {
      print('Otp error: $e');
      return null;
    }
  }

  Future<EmailOtpVerifiedResponseModel?> verifyEmailOtp(
      String emailId, String otp) async {
    print("verifyEmailOtp is api is going to called");
    String playerToken =
        await MySharedPreferences.instance.getStringValue("playerToken");
    String playerId =
        await MySharedPreferences.instance.getStringValue("playerId");
    print("playerId : $playerId type : ${playerId.runtimeType}");
    print("playerToken : $playerToken type : ${playerToken.runtimeType}");
    Map<String, String> headers = {
      "merchantCode": "INFINITI",
      "playerId": "411997",
      "playerToken": "1tqyqgAe7K232rUaXGQiPjKz1kUNzgdlOhWhBSWZptM",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> params = {
      "domainName": "www.winboom.ae",
      "emailId": emailId,
      "otp": otp,
      "merchantPlayerId": "411997"
    };
    try {
      final response = await http.post(
          Uri.parse(ApiConstants.RAM_URL + 'postLogin/verifyEmailWithOtp'),
          headers: headers,
          body: json.encode(params));
      print("Email Otp Verification response: ${response.body}");
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        print(' Email Otp verification result:$result');
        return EmailOtpVerifiedResponseModel.fromJson(result);
      } else {
        var result = jsonDecode(response.body);
        return EmailOtpVerifiedResponseModel.fromJson(result);
      }
    } catch (e) {
      print('Email Otp Verification error: $e');
      return null;
    }
  }

  Future<EmailOtpVerifiedResponseModel?> updatePlayerProfile(
      Profile profile) async {
    print("updatePlayerProfile is api is going to called");
    String playerToken =
        await MySharedPreferences.instance.getStringValue("playerToken");
    String playerId =
        await MySharedPreferences.instance.getStringValue("playerId");
    print("playerId : $playerId type : ${playerId.runtimeType}");
    print("playerToken : $playerToken type : ${playerToken.runtimeType}");
    Map<String, String> headers = {
      "merchantCode": "INFINITI",
      "playerId": playerId,
      "playerToken": playerToken,
      //"Content-Type" : "application/json"
      'Content-Type': 'multipart/form-data',
    };
    Map<String, dynamic> params = {
      "domainName": ApiCommon.domainName,
      "merchantPlayerId": playerId,
      'firstName': profile.firstName,
      'lastName': profile.lastName,
      'gender': profile.gender,
      'dob': profile.dateOfBirth,
      'nationality': 'INDIAN',
      'city': 'Dubai',
      'country': 'UNITED ARAB EMIRATES',
      'emailId': 'ab12@gmail.com',
      'stateCode': 'AE-DU',
      'timeZone': 'in',
      'documents[0].docExpiry': '2021-08-29 12:15:20',
      'documents[0].docName': 'BANK_STATEMENT',
      'documents[0].docType': 'BANK_PROOF',
    };
    print("headers : $headers");
    print("json.encode(params) : ${json.encode(params)}");
    try {
      final response = await http.post(
          Uri.parse(
              ApiConstants.RAM_URL + 'postLogin/overallUpdatePlayerProfile'),
          headers: headers,
          body: json.encode(params));
      print("updatePlayerProfile response: ${response.body}");
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        print(' updatePlayerProfile result:$result');
        //TODO need to change according to response
        return EmailOtpVerifiedResponseModel.fromJson(result);
      } else {
        var result = jsonDecode(response.body);
        //TODO need to change according to response
        return EmailOtpVerifiedResponseModel.fromJson(result);
      }
    } catch (e) {
      print('updatePlayerProfile error: $e');
      return null;
    }
  }

