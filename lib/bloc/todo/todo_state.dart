part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class SaveItemSuc extends TodoState {}

class LoadingTodo extends TodoState {}

class ErrorState extends TodoState {
  final String massage;

  ErrorState(this.massage);
}

class OpenDialog extends TodoState {}

class OpenUpdateDialog extends TodoState {
  final ToDoItem item;
  final int index;

  OpenUpdateDialog(this.item, this.index);
}

class CancelDialog extends TodoState {}

class DeleteSuc extends TodoState {}

class UpdateSuc extends TodoState {}

class ReceivedItems extends TodoState {
  final List<ToDoItem> items;

  ReceivedItems(this.items);
}
