import 'package:boom_lotto/src/data/model/login_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}

class Logining extends LoginState {}

class Logined extends LoginState {
  LoginModel loginModel;
  Logined({required this.loginModel});
}
