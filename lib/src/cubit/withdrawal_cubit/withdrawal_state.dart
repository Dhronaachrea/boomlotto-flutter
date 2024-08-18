import 'package:boom_lotto/src/data/model/payment_option_model.dart';

abstract class WithdrawalState {}

class WithdrawalInitial extends WithdrawalState {}

class WithdrawalError extends WithdrawalState {
  final String error;

  WithdrawalError({required this.error});
}

class Withdrawaling extends WithdrawalState {}

class Withdrawaled extends WithdrawalState {
  PaymentOptionModel paymentOption;
  Withdrawaled({required this.paymentOption});
}