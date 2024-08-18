abstract class SelectCountryCodeState {}

class SelectCountryCodeInitial extends SelectCountryCodeState {}
class SelectCountryCodeError extends SelectCountryCodeState {
  final String error;

  SelectCountryCodeError({required this.error});
}
class SelectCountryCodeAdded extends SelectCountryCodeState {
  var todos;
  SelectCountryCodeAdded({this.todos});
}