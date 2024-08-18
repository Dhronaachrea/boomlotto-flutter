import 'package:boom_lotto/src/cubit/resend_otp_cubit/resend_otp_state.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendOtpCubit extends Cubit<ResendOtpState> {
  final Repository repository;

  ResendOtpCubit({required this.repository}) : super(ResendOtpInitial());
  void getLogin(String mobileNumber) {
    if (mobileNumber.isEmpty) {
      emit(ResendOtpError(error: "Plz enter mobile Number!"));
      return;
    }

    emit(ResendingOtp());
    // repository.login(mobileNumber).then((result) {
    //   if (result != null) {
    //     // todosCubit.addTodo(todo);
    //     emit(ResendedOtp(loginModel: result));
    //   }
    // });
  }
}
