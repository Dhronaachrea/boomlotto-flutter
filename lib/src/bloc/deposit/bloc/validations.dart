import 'package:formz/formz.dart';

enum ValidationError { invalid }

class FirstName extends FormzInput<String, ValidationError> {
  const FirstName.pure([String value = '']) : super.pure(value);
  const FirstName.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return value.isEmpty ? ValidationError.invalid : null;
  }
}

class LastName extends FormzInput<String, ValidationError> {
  const LastName.pure([String value = '']) : super.pure(value);
  const LastName.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return value.isEmpty ? ValidationError.invalid : null;
  }
}

class DateOfBirth extends FormzInput<String, ValidationError> {
  const DateOfBirth.pure([String value = '']) : super.pure(value);
  const DateOfBirth.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return value.isEmpty ? ValidationError.invalid : null;
  }
}

class Nationality extends FormzInput<String, ValidationError> {
  const Nationality.pure([String value = '']) : super.pure(value);
  const Nationality.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return value.isEmpty ? ValidationError.invalid : null;
  }
}

class IdProofType extends FormzInput<String, ValidationError> {
  const IdProofType.pure([String value = '']) : super.pure(value);
  const IdProofType.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return value.isEmpty ? ValidationError.invalid : null;
  }
}

class IdNumber extends FormzInput<String, ValidationError> {
  const IdNumber.pure([String value = '']) : super.pure(value);
  const IdNumber.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    return value.isEmpty ? ValidationError.invalid : null;
  }
}
