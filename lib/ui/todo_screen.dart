import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import '../model/todo_item.dart';
import '../util/dateformatter.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final color = Colors.blue[100];
  final List<ToDoItem> _itemlist = <ToDoItem>[];
  List<ToDoItem> itemslist = <ToDoItem>[];
  @override
  void initState() {
    super.initState();
    _readTodoLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          print(state);
          if (state is ErrorState) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.massage),
              duration: Duration(milliseconds: 1200),
            ));
          } else if (state is DeleteSuc) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Delete Successful"),
              duration: Duration(milliseconds: 1200),
            ));
          } else if (state is OpenDialog) {
            _showFormDialog();
          } else if (state is SaveItemSuc) {
            _textEditingController.clear();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Added Successful"),
              duration: Duration(milliseconds: 1200),
            ));
            popFun();
          } else if (state is UpdateSuc) {
            _textEditingController.clear();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Update Successful"),
              duration: Duration(milliseconds: 1200),
            ));
            popFun();
          } else if (state is CancelDialog) {
          } else if (state is OpenUpdateDialog) {
            _textEditingController.text = state.item.itemName;
            _updateItemDialog(state.item, state.index);
          }
        },
        builder: (context, state) {
          if (state is ReceivedItems) {
            itemslist = state.items;
            return buildItems(state.items);
          } else if (state is LoadingTodo)
            return buildLoading();
          else
            return initalbuild();
        },
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// Widgets ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

  Widget initalbuild() {
    return itemslist.isEmpty
        ? Center(child: Text("No Date"))
        : buildItems(itemslist);
  }

  Widget buildItems(List<ToDoItem> list) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: list.length,
            itemBuilder: (_, int index) {
              return Card(
                color: Colors.blue,
                child: ListTile(
                  title: list[index],
                  onLongPress: () => openUpdateDialog(list[index], index),
                  trailing: Listener(
                    key: Key(list[index].itemName),
                    child: Icon(
                      Icons.delete_sweep,
                      color: Colors.white,
                    ),
                    onPointerDown: (pointerEvent) =>
                        _deleteTodo(list[index].id, index),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: 30.0,
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: openNewDialog,
      tooltip: "Add Item",
      backgroundColor: Colors.blueAccent,
      child: ListTile(
        title: Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Enter your todo title",
                  hintText: "eg.Buy stuffs",
                  icon: Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.blue,
          onPressed: () {
            saveItem(_textEditingController.text);
          },
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
        FlatButton(
          highlightColor: Colors.white,
          color: Colors.blueGrey,
          onPressed: cancelDialog,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _updateItemDialog(ToDoItem item, int index) {
    var alert = AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "e.g update ",
                  icon: Icon(Icons.update)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => updateItem(index, _textEditingController.text),
          child: Text("Update"),
        ),
        FlatButton(
          onPressed: cancelDialog,
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// Functions ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

  void popFun() => Navigator.pop(context);

  _readTodoLists() => context.bloc<TodoBloc>().add(GetItemData());

  _deleteTodo(int id, int index) =>
      context.bloc<TodoBloc>().add(DeleteEvent(index));

  openNewDialog() => context.bloc<TodoBloc>().add(OpenNewDialogEvent());

  openUpdateDialog(ToDoItem item, int index) =>
      context.bloc<TodoBloc>().add(OpenUpdateDialogEvent(item, index));

  cancelDialog() => context.bloc<TodoBloc>().add(CancelDialogEvent());

  saveItem(String text) => context
      .bloc<TodoBloc>()
      .add(SaveItemFromDialog(ToDoItem(text, dateFormatted())));

  updateItem(int index, String text) => context
      .bloc<TodoBloc>()
      .add(UpdateItemFromDialog(ToDoItem(text, dateFormatted()), index));
}
