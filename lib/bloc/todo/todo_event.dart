part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class GetItemData extends TodoEvent {}

class OpenNewDialogEvent extends TodoEvent {}

class OpenUpdateDialogEvent extends TodoEvent {
  final ToDoItem item;
  final int index;

  OpenUpdateDialogEvent(this.item, this.index);
}

class SaveItemFromDialog extends TodoEvent {
  final ToDoItem item;

  SaveItemFromDialog(this.item);
}

class UpdateItemFromDialog extends TodoEvent {
  final ToDoItem item;
  final int index;

  UpdateItemFromDialog(this.item, this.index);
}

class CancelDialogEvent extends TodoEvent {}

class DeleteEvent extends TodoEvent {
  final int index;

  DeleteEvent(this.index);
}
