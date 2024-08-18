import 'package:bloc/bloc.dart';
import 'package:boom_lotto/src/bloc/deposit/bloc/validations.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'deposit_event.dart';
part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  DepositBloc() : super(const DepositState()) {
    on<FormSubmitted>(_onFormSubmitted);
  }

  void _onFormSubmitted(FormSubmitted event, Emitter<DepositState> emit) async {
    final firstName = FirstName.dirty(event.firstName);
    final lastName = LastName.dirty(event.lastName);
    final dateOfBirth = DateOfBirth.dirty(event.dateOfBirth);
    final nationality = Nationality.dirty(event.nationality);
    final idProofType = IdProofType.dirty(event.idProofType);
    final idNumber = IdNumber.dirty(event.idNumber);
    emit(
      state.copyWith(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        nationality: nationality,
        idProofType: idProofType,
        idNumber: idNumber,
        status: Formz.validate([
          firstName,
          lastName,
          dateOfBirth,
          nationality,
          idProofType,
          idNumber
        ]),
      ),
    );

    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } else {
      print("invalid");
    }
  }
}
