import 'package:bloc/bloc.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'game_list_state.dart';

class GameListCubit extends Cubit<GameListState> {
  final Repository repository;
  GameListCubit({required this.repository}) : super(GameListInitial());

  void fetchGameList() {
    repository.fetchGameList().then((result) {
      emit(GameListLoaded(todos: result));
    });
  }
}
