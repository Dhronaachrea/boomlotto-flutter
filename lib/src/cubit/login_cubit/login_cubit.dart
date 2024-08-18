import 'package:boom_lotto/src/cubit/login_cubit/login_state.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final Repository repository;

  LoginCubit({required this.repository}) : super(LoginInitial());
  void getLogin(String countryCode,String mobileNumber) {
    if (mobileNumber.isEmpty) {
      emit(LoginError(error: "Plz enter mobile Number!"));
      return;
    }

    emit(Logining());
    repository.login(countryCode,mobileNumber).then((result) {
      if (result != null) {
        // todosCubit.addTodo(todo);
        emit(Logined(loginModel: result));
      }
      else
        emit(LoginError(error: 'Server Error!'));
    });
  }
}
