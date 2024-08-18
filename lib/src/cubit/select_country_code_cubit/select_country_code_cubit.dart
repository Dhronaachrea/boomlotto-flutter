import 'package:boom_lotto/src/cubit/country_list_cubit/country_list_cubit.dart';
import 'package:boom_lotto/src/cubit/select_country_code_cubit/select_country_code_state.dart';
import 'package:boom_lotto/src/data/model/country_list_model.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCountryCodeCubit extends Cubit<SelectCountryCodeState> {
  final Repository repository;
  final CountryListCubit countryListCubit;

  SelectCountryCodeCubit(
      {required this.repository, required this.countryListCubit})
      : super(SelectCountryCodeInitial());

  void updateTodo(CountryListModel countryListModel, var data, int index) {
    countryListModel.data![index] = countryListModel.data![0];
    countryListModel.data![0] = data;
    countryListCubit.updateTodoList();
    emit(SelectCountryCodeAdded());
  }
}
