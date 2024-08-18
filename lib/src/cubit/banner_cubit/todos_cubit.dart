import 'package:bloc/bloc.dart';
import 'package:boom_lotto/src/cubit/banner_cubit/todos_state.dart';
import 'package:boom_lotto/src/data/repository.dart';

class TodosCubit extends Cubit<TodosState>
{
  final Repository repository;
  TodosCubit({required this.repository}) : super(TodosInitial());

  void fetchTodos() {
    repository.fetchTodos().then((todos) {
      emit(TodosLoaded(todos: todos));
    });
  }
}