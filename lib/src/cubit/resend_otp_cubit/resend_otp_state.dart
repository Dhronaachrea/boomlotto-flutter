import 'package:boom_lotto/src/data/model/resend_otp_model.dart';

abstract class ResendOtpState {}

class ResendOtpInitial extends ResendOtpState {}

class ResendOtpError extends ResendOtpState {
  final String error;

  ResendOtpError({required this.error});
}

class ResendingOtp extends ResendOtpState {}

class ResendedOtp extends ResendOtpState {
  ResendOtpModel resendOtpModel;
  ResendedOtp({required this.resendOtpModel});
}
