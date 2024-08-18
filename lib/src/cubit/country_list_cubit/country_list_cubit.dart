import 'package:bloc/bloc.dart';
import 'package:boom_lotto/src/data/model/country_list_model.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'country_list_state.dart';

class CountryListCubit extends Cubit<CountryListState> {
  final Repository repository;
  CountryListCubit({required this.repository}) : super(CountryListInitial());

  void fetchCountryList() {
    repository.fetchCountryList().then((result) {
      emit(CountryListLoaded(countryListModel: result as CountryListModel));
    });
  }

  void updateTodoList() {
    final currentState = state;
    if (currentState is CountryListLoaded) {
      emit(CountryListLoaded(countryListModel: currentState.countryListModel));
    }
  }
}
