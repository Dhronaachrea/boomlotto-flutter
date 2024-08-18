import 'package:bloc/bloc.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'game_info_state.dart';

class GameInfoCubit extends Cubit<GameInfoState>
{
  final Repository repository;
  GameInfoCubit({required this.repository}) : super(GameInfoInitial());

  void fetchGameInfo() {
    repository.fetchGameInfo().then((result) {
      emit(GameInfoLoaded(todos: result));
    });
  }
}