import 'dart:async';
import 'package:boom_lotto/src/data/model/login_model.dart';
import 'package:boom_lotto/src/data/model/referral_code_model.dart';
import 'package:boom_lotto/src/data/model/signup_model.dart';

import 'model/country_list_model.dart';
import 'model/email_otp_verified_model.dart';
import 'model/emailed_otp_response_model.dart';
import 'model/game_info_model.dart';
import 'model/game_list_model.dart';
import 'model/payment_option_model.dart';
import 'model/profile.dart';
import 'model/todo.dart';
import 'model/transaction_list_model.dart';
import 'network_service.dart';

class Repository {
  final NetworkService networkService;
  Repository({required this.networkService});

  Future<Todo?> fetchTodos() async {
    final result = await networkService.fetchTodos();
    return result;
  }

  Future<GameInfoModel?> fetchGameInfo() async {
    final result = await networkService.fetchGameInfo();
    return result;
  }

  Future<GameListModel?> fetchGameList() async {
    final result = await networkService.fetchGameList();
    return result;
  }

  Future<LoginModel?> login(String countryCode,String mobileNumber) async {
    final result = await networkService.login(countryCode+mobileNumber);
    return result;
  }

  Future<CountryListModel?> fetchCountryList() async {
    final result = await networkService.fetchCountryList();
    return result;
  }

  Future<SignUpModel?> signUp(var param) async {
    final result = await networkService.signUp(param);
    return result;
  }

  Future<ReferralCodeModel?> referralCode(String referralNumber) async {
    final result = await networkService.referralCode(referralNumber);
    return result;
  }

  Future<TransactionListModel?> fetchTransactionList(Map<String, dynamic> request) async {
    final result = await networkService.fetchTransactionList(request);
    return result;
  }
  Future<PaymentOptionModel?> paymentOptions() async {
    // return await networkService.paymentOptions();
  }

  Future<EmailedOtpResponseModel?> getEmailOtp(String emailId) async {
    // return await networkService.getEmailOtp(emailId);
  }
  Future<EmailOtpVerifiedResponseModel?> verifyEmailOtp(String emailId,String otp) async {
    // return await networkService.verifyEmailOtp(emailId, otp);
  }
  Future<EmailOtpVerifiedResponseModel?> updatePlayerProfile(Profile profile) async {
    // return await networkService.updatePlayerProfile(profile);
  }
}
