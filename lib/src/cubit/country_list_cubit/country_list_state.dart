
import 'package:boom_lotto/src/data/model/country_list_model.dart';

abstract class CountryListState {}

class CountryListInitial extends CountryListState {}
class CountryListLoading extends CountryListState {}
class CountryListLoaded extends CountryListState {
  CountryListModel countryListModel;
  CountryListLoaded({required this.countryListModel});
}