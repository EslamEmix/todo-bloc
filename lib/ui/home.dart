import 'package:flutter/material.dart';
import 'todo_screen.dart';

class HomeScreen extends StatelessWidget {
  static const ROUTE_NAME = "home-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do"),
        backgroundColor: Colors.indigoAccent,
      ),
      body: ToDoScreen(),
    );
  }
}
