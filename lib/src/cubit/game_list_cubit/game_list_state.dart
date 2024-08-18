
abstract class GameListState {}

class GameListInitial extends GameListState {}
class GameListLoading extends GameListState {}
class GameListLoaded extends GameListState {
  var todos;
  GameListLoaded({required this.todos});
}