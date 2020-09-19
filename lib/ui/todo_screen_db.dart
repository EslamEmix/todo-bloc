import 'package:flutter/material.dart';
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

  void _handleSubmit(String text) async {
    _textEditingController.clear();
    ToDoItem toDoItem = ToDoItem(text, dateFormatted());
    // int savedItemID = await db.saveItem(toDoItem);
    // ToDoItem addedItem = await db.getItem(savedItemID);
    setState(() {
      _itemlist.insert(0, toDoItem);
    });
    // print("Item saved Id is $savedItemID");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Column(
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
                    onLongPress: () => _updateItem(_itemlist[index], index),
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
            _textEditingController.clear();
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
            print("Cancled succesfully");
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

  _readTodoLists() async {
    // List items = await db.getItems();
    // items.forEach((item) {
    //   ToDoItem toDoItem = ToDoItem.fromMap(item);
    //   setState(() {
    //     _itemlist.add(ToDoItem.map(item));
    //   });
    //   print("Db items ${toDoItem.itemName}");
    // });
  }

  _deleteTodo(int id, int index) async {
    // debugPrint("Deleted items");
    // await db.deleteItem(id);
    setState(() {
      _itemlist.removeAt(index);
    });
  }

  _updateItem(ToDoItem item, int index) {
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
          onPressed: () async {
            ToDoItem newItemupdated = ToDoItem.fromMap(
                //
                {
                  "itemName": _textEditingController.text,
                  "dateCreated": dateFormatted(),
                  "id": item.id
                });
            _handleSubmittedUpdated(index, item);
            // await db.updateItem(newItemupdated);
            setState(() {
              _readTodoLists();
            });
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

  void _handleSubmittedUpdated(int index, ToDoItem item) {
    setState(() {
      _itemlist.removeWhere((element) {
        _itemlist[index].itemName == item.itemName;
      });
    });
  }
}
