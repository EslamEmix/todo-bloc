import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo/bloc/todo/repo.dart';
import 'package:todo/model/todo_item.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final BaseTodoRepo todoRepo;

  TodoBloc(this.todoRepo) : super(TodoInitial());

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    if (event is GetItemData) {
      yield LoadingTodo();
      yield await todoRepo.getTodoItems();
    } else if (event is DeleteEvent) {
      yield await todoRepo.deleteTodoItem(event.index);
      yield LoadingTodo();
      yield await todoRepo.deleteTodoItem(event.index);
    } else if (event is OpenNewDialogEvent) {
      yield OpenDialog();
    } else if (event is CancelDialogEvent) {
      yield CancelDialog();
    } else if (event is SaveItemFromDialog) {
      yield LoadingTodo();
      yield await todoRepo.addTodoItem(event.item);
    } else if (event is UpdateItemFromDialog) {
      yield LoadingTodo();
      yield await todoRepo.updateItem(event.item, event.index);
    } else if (event is OpenUpdateDialogEvent) {
      yield OpenUpdateDialog(event.item, event.index);
    }
  }
}
