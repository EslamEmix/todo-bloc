import 'dart:math';

import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/model/todo_item.dart';
import 'package:todo/util/database_client.dart';

import 'damy.dart';

abstract class BaseTodoRepo {
  Future<TodoState> addTodoItem(ToDoItem data);

  Future<TodoState> getTodoItems();

  Future<TodoState> deleteTodoItem(int index);

  Future<TodoState> updateItem(ToDoItem item, int index);
}

class TodoRepo implements BaseTodoRepo {
  final DatabaseHelper db = DatabaseHelper.internal();
  TodoState todoState;

  @override
  Future<TodoState> addTodoItem(ToDoItem data) async {
    int x = await db.saveItem(data);
    //print(x);
    if (x > 0) {
      todoState = SaveItemSuc();
    } else
      todoState = ErrorState("Pls try again later");

    return todoState;
    // TODO: implement addTodoItem
    throw UnimplementedError();
  }

  @override
  Future<TodoState> deleteTodoItem(int index) async {
    int x = await db.deleteItem(index);
    if (x == 1) {
      todoState = DeleteSuc();
    } else
      todoState = ErrorState("Pls try again later");

    return todoState;
    // TODO: implement deleteTodoItem
    throw UnimplementedError();
  }

  @override
  Future<TodoState> getTodoItems() async {
    final list = await db.getItems();
    if (list.length >= 0) {
      List<ToDoItem> todoList = list.map((e) => ToDoItem.fromMap(e)).toList();
      todoState = ReceivedItems(todoList);
    } else
      todoState = ErrorState("Pls try again later");

    return todoState;

    // TODO: implement getTodoItems
    throw UnimplementedError();
  }

  @override
  Future<TodoState> updateItem(ToDoItem item, int index) async {
    ToDoItem toDoUpdate = ToDoItem.fromMap({
      'id': index,
      'itemName': item.itemName,
      'dateCreated': item.dateCreated
    });
    int x = await db.updateItem(toDoUpdate);
    if (x == 1) {
      todoState = UpdateSuc();
    } else
      todoState = ErrorState("Pls try again later");

    return todoState;

    // TODO: implement updateItem
    throw UnimplementedError();
  }
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
