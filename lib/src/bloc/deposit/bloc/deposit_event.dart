part of 'deposit_bloc.dart';

abstract class DepositEvent extends Equatable {
  const DepositEvent();

  @override
  List<Object> get props => [];
}

class FormSubmitted extends DepositEvent {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String nationality;
  final String idProofType;
  final String idNumber;

  const FormSubmitted({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.nationality,
    required this.idProofType,
    required this.idNumber,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        dateOfBirth,
        nationality,
        idProofType,
        idNumber,
      ];
}
