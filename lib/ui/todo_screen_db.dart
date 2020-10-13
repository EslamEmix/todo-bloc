import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import '../model/todo_item.dart';
import '../util/database_client.dart';
import '../util/dateformatter.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  // var db = DatabaseHelper();
  final List<ToDoItem> _itemlist = <ToDoItem>[];

  @override
  void initState() {
    super.initState();
    _readTodoLists();
  }

  void _handleSubmit(String text) {
    _textEditingController.clear();
    ToDoItem toDoItem = ToDoItem(text, dateFormatted());
    BlocProvider.of<TodoBloc>(context).add(SaveItemFromDialog(toDoItem));

    // print("Item saved Id is $savedItemID");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is SaveItemSuc) {
            _readTodoLists();
            showSnack(context, "Item Saved");
          } else if (state is DeleteSuc) {
            _readTodoLists();
            showSnack(context, "Item Deleted");
          } else if (state is UpdateSuc) {
            _readTodoLists();
            showSnack(context, "Item Updated");
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
          if (state is ReceivedItems) {
            _itemlist.clear();
            _itemlist.addAll(state.items);
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _itemlist.length,
                    itemBuilder: (_, int index) {
                      return Card(
                        color: Colors.blue,
                        child: ListTile(
                          title: _itemlist[index],
                          onLongPress: () =>
                              _updateItem(_itemlist[index], index),
                          trailing: Listener(
                            key: Key(_itemlist[index].itemName),
                            child: Icon(
                              Icons.delete_sweep,
                              color: Colors.white,
                            ),
                            onPointerDown: (pointerEvent) =>
                                _deleteTodo(_itemlist[index].id, index),
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
          } else if (state is ErrorState) {
            return Center(
              child: Text(state.massage),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialouge,
        tooltip: "Add Item",
        backgroundColor: Colors.blueAccent,
        child: ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }

  void showSnack(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1200),
    ));
  }

  void _showFormDialouge() {
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
            _handleSubmit(_textEditingController.text);
            Navigator.pop(context);
          },
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
        FlatButton(
          highlightColor: Colors.white,
          color: Colors.blueGrey,
          onPressed: () {
            Navigator.pop(context);
            //print("Cancled succesfully");
          },
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

  _readTodoLists() {
    BlocProvider.of<TodoBloc>(context).add(GetItemData());
  }

  _deleteTodo(int id, int index) {
    // debugPrint("Deleted items");
    // await db.deleteItem(id);
    BlocProvider.of<TodoBloc>(context).add(DeleteEvent(id));
  }

  _updateItem(ToDoItem item, int index) {
    _textEditingController.text = item.itemName;
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
                  //hintText: "e.g update ",
                  icon: Icon(Icons.update)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            _handleSubmittedUpdated(item);
            // await db.updateItem(newItemupdated);
            Navigator.pop(context);
          },
          child: Text("Update"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancle"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdated(ToDoItem item) {
    ToDoItem toDoItem = ToDoItem(_textEditingController.text, dateFormatted());
    print(toDoItem.itemName);
    _textEditingController.clear();
    BlocProvider.of<TodoBloc>(context)
        .add(UpdateItemFromDialog(toDoItem, item.id));
  }
}
