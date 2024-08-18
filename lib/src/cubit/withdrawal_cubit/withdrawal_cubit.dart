import 'package:boom_lotto/src/cubit/withdrawal_cubit/withdrawal_state.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawalCubit extends Cubit<WithdrawalState> {
  final Repository repository;

  WithdrawalCubit({required this.repository}) : super(WithdrawalInitial());
  void getPaymentOption() {
    repository.paymentOptions().then((paymentOption) {
      if (paymentOption != null) {
        emit(Withdrawaled(paymentOption:paymentOption));
      }
    });
  }
}