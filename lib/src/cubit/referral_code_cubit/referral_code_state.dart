import 'package:boom_lotto/src/data/model/referral_code_model.dart';

abstract class ReferralCodeState {}

class ReferralCodeInitial extends ReferralCodeState {}

class ReferralCodeError extends ReferralCodeState {
  final String error;

  ReferralCodeError({required this.error});
}

class ReferralingCode extends ReferralCodeState {}

class ReferraledCode extends ReferralCodeState {
  ReferralCodeModel referralCodeModel;
  ReferraledCode({required this.referralCodeModel});
}
