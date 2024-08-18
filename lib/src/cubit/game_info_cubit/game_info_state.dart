
abstract class GameInfoState {}

class GameInfoInitial extends GameInfoState {}
class GameInfoLoading extends GameInfoState {}
class GameInfoLoaded extends GameInfoState {
   var todos;
  GameInfoLoaded({required this.todos});
}