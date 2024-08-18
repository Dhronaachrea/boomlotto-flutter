import 'package:boom_lotto/src/cubit/referral_code_cubit/referral_code_state.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReferralCodeCubit extends Cubit<ReferralCodeState> {
  final Repository repository;

  ReferralCodeCubit({required this.repository}) : super(ReferralCodeInitial());
  void getReferralCode(String referralNumber) {
    if (referralNumber.isEmpty) {
      emit(ReferralCodeError(error: "Plz enter referral Number!"));
      return;
    }

    emit(ReferralingCode());
    repository.referralCode(referralNumber).then((result) {
      if (result != null) {
        emit(ReferraledCode(referralCodeModel: result));
      }
    });
  }
}
