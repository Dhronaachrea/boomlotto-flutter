part of 'deposit_bloc.dart';

enum DepositStatus {
  initial,
  valid,
  invalid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure
}

class DepositState extends Equatable {
  const DepositState({
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.dateOfBirth = const DateOfBirth.pure(),
    this.nationality = const Nationality.pure(),
    this.idProofType = const IdProofType.pure(),
    this.idNumber = const IdNumber.pure(),
    this.status = FormzStatus.pure,
  });

  final FormzStatus status;
  final FirstName firstName;
  final LastName lastName;
  final DateOfBirth dateOfBirth;
  final Nationality nationality;
  final IdProofType idProofType;
  final IdNumber idNumber;

  DepositState copyWith({
    FormzStatus? status,
    FirstName? firstName,
    LastName? lastName,
    DateOfBirth? dateOfBirth,
    Nationality? nationality,
    IdProofType? idProofType,
    IdNumber? idNumber,
  }) {
    return DepositState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      idProofType: idProofType ?? this.idProofType,
      idNumber: idNumber ?? this.idNumber,
    );
  }

  @override
  List<Object> get props => [
        firstName,
        lastName,
        dateOfBirth,
        nationality,
        idProofType,
        idNumber,
        status,
      ];
}
