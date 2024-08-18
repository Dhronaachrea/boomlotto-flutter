import 'package:bloc/bloc.dart';
import 'package:boom_lotto/src/data/model/profile.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:equatable/equatable.dart';

part 'verification_withdrawal_state.dart';

class VerificationWithdrawalCubit extends Cubit<VerificationWithdrawalState> {
  final Repository repository;
  VerificationWithdrawalCubit({required this.repository}) : super(VerificationWithdrawalInitial());
    updatePlayerProfile(Profile profile){
      if (profile.firstName == null ||profile.firstName == '') {
        emit(const VerificationWithdrawalError(error: "Please enter firstName"));
        return;
      }else if (profile.lastName == null || profile.lastName == '') {
        emit(const VerificationWithdrawalError(error: "Please enter lastName"));
        return;
      }else if (profile.dateOfBirth == null || profile.dateOfBirth == '') {
        emit(const VerificationWithdrawalError(error: "Please select Date of birth"));
        return;
      }else if (profile.gender == null || profile.gender == '') {
        emit(const VerificationWithdrawalError(error: "Please select gender"));
        return;
      }else if (profile.nationality == null || profile.nationality == '') {
        emit(const VerificationWithdrawalError(error: "Please select Nationality"));
        return;
      }else if (profile.idNumber == null || profile.idNumber == '') {
        emit(const VerificationWithdrawalError(error: "Please enter ID Number"));
        return;
      }else if (profile.expirtyDateOfId == null || profile.expirtyDateOfId == '') {
        emit(const VerificationWithdrawalError(error: "Please select expiry date of Id proof"));
        return;
      }
      print(" updatePlayerProfile api is going to be called");
      repository.updatePlayerProfile(profile).then((response) {
        if (response!.errorMessage == "Success") {
          emit(VeificationWithdrawaled(success:response.errorMessage??"Please fill the bank details"));
        } else{
          emit(VerificationWithdrawalError(error: response.errorMessage??"Please complete the details first"));
          return;
        }
      });

   }
}
