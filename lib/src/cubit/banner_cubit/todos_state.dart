
abstract class TodosState {}

class TodosInitial extends TodosState {}
class TodosLoading extends TodosState {}
class TodosLoaded extends TodosState {
   var todos;
  TodosLoaded({required this.todos});

}