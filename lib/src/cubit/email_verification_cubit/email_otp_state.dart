part of 'email_otp_cubit.dart';

@immutable
abstract class EmailOtpState extends Equatable{}

class EmailOtpInitial extends EmailOtpState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}


class EmailOtpError extends EmailOtpState {
  final String error;

  EmailOtpError({required this.error});
  @override
  List<Object> get props => [error];
}
class VerifyOtpError extends EmailOtpState {
  final String error;

  VerifyOtpError({required this.error});
  @override
  List<Object> get props => [error];
}
class EmailingOtp extends EmailOtpState {
  @override
  List<Object?> get props => throw UnimplementedError();

}

class EmailedOtp extends EmailOtpState {
 final String success;
 EmailedOtp({required this.success});
 @override
 List<Object> get props => [success];
}

class VerifiedOtp extends EmailOtpState {
  final String success;
  VerifiedOtp({required this.success});
  @override
  List<Object> get props => [success];
}
