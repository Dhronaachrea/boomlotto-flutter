import 'package:boom_lotto/src/cubit/sign_up_cubit/sign_up_state.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final Repository repository;

  SignUpCubit({required this.repository}) : super(SignUpInitial());
  void getSignUp(var param, var otpNumber) {
    if (otpNumber.isEmpty) {
      emit(SignUpError(error: "Plz enter otp Number!"));
      return;
    }

    emit(SigningUp());
    repository.signUp(param).then((result) {
      if (result != null) {
        emit(SignedUp(signUpModel: result));
      }
      else
        emit(SignUpError(error: 'Server Error!'));
    });
  }
}
