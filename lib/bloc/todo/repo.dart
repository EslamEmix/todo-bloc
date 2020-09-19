import 'dart:math';

import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/model/todo_item.dart';

import 'damy.dart';

abstract class BaseTodoRepo {
  Future<TodoState> addTodoItem(ToDoItem data);
  Future<TodoState> getTodoItems();
  Future<TodoState> deleteTodoItem(int index);
  Future<TodoState> updateItem(ToDoItem item, int index);
}

class FakeTodoRepo implements BaseTodoRepo {
  @override
  Future<TodoState> addTodoItem(ToDoItem data) async {
    TodoState todoState;
    Random random = Random();
    int x = 0;
    await Future.delayed(Duration(seconds: 1), () {
      x = random.nextInt(2);
      print(x);
      if (x == 0) {
        itemsData.add(data);
        todoState = SaveItemSuc();
      } else
        todoState = ErrorState("Pls try again later");
    });

    return todoState;
  }

  @override
  Future<TodoState> updateItem(ToDoItem data, int index) async {
    TodoState todoState;
    Random random = Random();
    int x = 0;
    await Future.delayed(Duration(seconds: 1), () {
      x = random.nextInt(2);
      print(x);
      if (x == 0) {
        itemsData[index] = data;
        todoState = UpdateSuc();
      } else
        todoState = ErrorState("Pls try again later");
    });

    return todoState;
  }

  @override
  Future<TodoState> getTodoItems() async {
    TodoState todoState;
    Random random = Random();
    int x = 0;
    await Future.delayed(Duration(seconds: 1), () {
      x = random.nextInt(2);
      print(x);
      if (x == 0) {
        todoState = ReceivedItems(itemsData);
      } else
        todoState = ErrorState("Pls try again later");
    });

    todoState = ReceivedItems(itemsData);
    return todoState;
  }

  @override
  Future<TodoState> deleteTodoItem(int i) async {
    TodoState todoState;
    Random random = Random();
    int x = 0;
    await Future.delayed(Duration(seconds: 1), () {
      x = random.nextInt(2);
      print(x);
      if (x == 0) {
        itemsData.removeAt(i);
        todoState = DeleteSuc();
      } else
        todoState = ErrorState("Delete Filar");
    });

    return todoState;
  }
}
