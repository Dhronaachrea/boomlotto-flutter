import 'package:bloc/bloc.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'email_otp_state.dart';

class EmailOtpCubit extends Cubit<EmailOtpState> {
  final Repository repository;
  EmailOtpCubit({required this.repository}) : super(EmailOtpInitial());

  void getEmailOtp(String amount, String emailId){
    if (amount.isEmpty) {
      emit(EmailOtpError(error: "Please enter an amount"));
      return;
    }else if (emailId.isEmpty) {
      emit(EmailOtpError(error: "Please enter email id"));
      return;
    }
    repository.getEmailOtp(emailId).then((response) {
      if (response!.errorMessage == "Success") {
        emit(EmailedOtp(success:response.errorMessage??"Otp sent Successfully"));
      } else{
        emit(EmailOtpError(error: response.errorMessage??"Plz enter valid email id"));
        return;
      }
    });
  }
  void verifyEmailOtp(String amount, String emailId, String otp){
    if (amount.isEmpty) {
      emit(VerifyOtpError(error: "Plz enter an amount"));
      return;
    }else if (emailId.isEmpty) {
      emit(VerifyOtpError(error: "Plz enter an emailId"));
      return;
    }
    else if (otp.isEmpty) {
      emit(VerifyOtpError(error: "Plz enter otp"));
      return;
    }
    repository.verifyEmailOtp(emailId , otp).then((response) {
      if (response!.errorMessage == "Success") {
        emit(VerifiedOtp(success:response.errorMessage??"Otp verified Successfully"));
      }else{
        emit(VerifyOtpError(error: response.errorMessage??"Plz enter correct otp"));
        return;
      }
    });
  }

}

