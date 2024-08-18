part of 'verification_withdrawal_cubit.dart';

abstract class VerificationWithdrawalState extends Equatable {
  const VerificationWithdrawalState();
}

class VerificationWithdrawalInitial extends VerificationWithdrawalState {
  @override
  List<Object> get props => [];
}


class VerificationWithdrawalError extends VerificationWithdrawalState {
  final String error;

  const VerificationWithdrawalError({required this.error});

  @override
  List<Object> get props => [error];
}

class VerificationWithdrawaling extends VerificationWithdrawalState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class VeificationWithdrawaled extends VerificationWithdrawalState {
  final String success;
  const VeificationWithdrawaled({required this.success});
  @override
  List<Object> get props => [success];
}