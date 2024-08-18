import 'package:boom_lotto/src/data/model/signup_model.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpError extends SignUpState {
  final String error;

  SignUpError({required this.error});
}

class SigningUp extends SignUpState {}

class SignedUp extends SignUpState {
  SignUpModel signUpModel;
  SignedUp({required this.signUpModel});
}
